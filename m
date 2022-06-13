Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407D7548CA5
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240955AbiFMN72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380431AbiFMN65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:58:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D088BD17;
        Mon, 13 Jun 2022 04:37:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C18B16130D;
        Mon, 13 Jun 2022 11:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F72C34114;
        Mon, 13 Jun 2022 11:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120254;
        bh=2Ql0a/vPelV0bL+jBTjKjr1EkxwWCwzwREcV0w+3uFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6mirt2lVIMd+uHkHxv2vuVERIdW/mei+YTW91H0Vj6jqKBiMLtZhTNAbE1VNqwUJ
         ryi0lDRuTF3GAdCwYqrcW02/jtw/DHKMUzpf4M+lIUagWJOhnlnaIwL+syL7QBZgGX
         BSvuxDE6O5EnxD7tAvly7Nd5mTWy2PHwPTFZaj5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 287/339] scsi: lpfc: Correct BDE type for XMIT_SEQ64_WQE in lpfc_ct_reject_event()
Date:   Mon, 13 Jun 2022 12:11:52 +0200
Message-Id: <20220613094935.336834991@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 44ba9786b67345dc4e5eabe537c9ef2bfd889888 ]

A previous commit assumed all XMIT_SEQ64_WQEs are prepped with the correct
BDE type in word 0-2.  However, lpfc_ct_reject_event() routine was missed
and is still filling out the incorrect BDE type.

Fix lpfc_ct_reject_event() routine so that type BUFF_TYPE_BDE_64 is set
instead of BUFF_TYPE_BLP_64.

Link: https://lore.kernel.org/r/20220603174329.63777-2-jsmart2021@gmail.com
Fixes: 596fc8adb171 ("scsi: lpfc: Fix dmabuf ptr assignment in lpfc_ct_reject_event()")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 4b024aa03c1b..87124fd65272 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -197,7 +197,7 @@ lpfc_ct_reject_event(struct lpfc_nodelist *ndlp,
 	memset(bpl, 0, sizeof(struct ulp_bde64));
 	bpl->addrHigh = le32_to_cpu(putPaddrHigh(mp->phys));
 	bpl->addrLow = le32_to_cpu(putPaddrLow(mp->phys));
-	bpl->tus.f.bdeFlags = BUFF_TYPE_BLP_64;
+	bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
 	bpl->tus.f.bdeSize = (LPFC_CT_PREAMBLE - 4);
 	bpl->tus.w = le32_to_cpu(bpl->tus.w);
 
-- 
2.35.1



