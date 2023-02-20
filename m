Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6128B69CC6E
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbjBTNkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjBTNkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:40:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05AC1C321
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4BF08CE0F6D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F28C433EF;
        Mon, 20 Feb 2023 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900411;
        bh=hPAMbIlzgKziRF/O0aOaYGNYHSfbFTIFLmfBdTeAQOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=blMSTQDgtMgsS/IL1insSuXtyWwIwl8k6na9BTbIKjveRA69krUTIBN3TRvDcpfNg
         caLD2fdBh2mN1+G4YpaIRS8hYXXBx1MeFY8eT6a1IO0u1ZxRz6qkaCAzyoiyk4MEQP
         Qm9PwDBmGBTqlnIRvX3bbPBUyIdMzHr4lymWfOms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, John Keeping <john@metanate.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/89] usb: gadget: f_fs: Fix unbalanced spinlock in __ffs_ep0_queue_wait
Date:   Mon, 20 Feb 2023 14:35:14 +0100
Message-Id: <20230220133553.656104539@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Udipto Goswami <quic_ugoswami@quicinc.com>

[ Upstream commit 921deb9da15851425ccbb6ee409dc2fd8fbdfe6b ]

__ffs_ep0_queue_wait executes holding the spinlock of &ffs->ev.waitq.lock
and unlocks it after the assignments to usb_request are done.
However in the code if the request is already NULL we bail out returning
-EINVAL but never unlocked the spinlock.

Fix this by adding spin_unlock_irq &ffs->ev.waitq.lock before returning.

Fixes: 6a19da111057 ("usb: gadget: f_fs: Prevent race during ffs_ep0_queue_wait")
Reviewed-by: John Keeping <john@metanate.com>
Signed-off-by: Udipto Goswami <quic_ugoswami@quicinc.com>
Link: https://lore.kernel.org/r/20230124091149.18647-1-quic_ugoswami@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 48bdb2a3972b..f9f324f76a72 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -271,8 +271,10 @@ static int __ffs_ep0_queue_wait(struct ffs_data *ffs, char *data, size_t len)
 	struct usb_request *req = ffs->ep0req;
 	int ret;
 
-	if (!req)
+	if (!req) {
+		spin_unlock_irq(&ffs->ev.waitq.lock);
 		return -EINVAL;
+	}
 
 	req->zero     = len < le16_to_cpu(ffs->ev.setup.wLength);
 
-- 
2.39.0



