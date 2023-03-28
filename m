Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B87B6CC57D
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbjC1POp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbjC1PO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:14:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04501117B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:13:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E0BCB81D8A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81417C433D2;
        Tue, 28 Mar 2023 15:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016076;
        bh=CC6o8uVID/Rbji18ccA2xOWJgD9dnCYuRdb3McZHhMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/FkQ52rulsgoRUfrT34S6rcGquoZXBPSHRgn+7CiBY4Ox8kp5AlJasFAlAuleuZL
         KpaNBYzJ1x6VgeTqg7eWryC4LYZD+VaH+dOVTAJrLSqWkUhpfuP4zGPMmmwnKq0Kbd
         NG1y8obo4SIIxUdHJ+Ksh7iHs26GYe9HTDeLEotw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/146] ksmbd: add low bound validation to FSCTL_SET_ZERO_DATA
Date:   Tue, 28 Mar 2023 16:42:25 +0200
Message-Id: <20230328142605.043329465@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 2d74ec97131b1179a373b6d521f195c84e894eb6 ]

Smatch static checker warning:
 fs/ksmbd/smb2pdu.c:7759 smb2_ioctl()
 warn: no lower bound on 'off'

Fix unexpected result that could caused from negative off and bfz.

Fixes: b5e5f9dfc915 ("ksmbd: check invalid FileOffset and BeyondFinalZero in FSCTL_ZERO_DATA")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index ac029dfd23ab8..305313abbc24b 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7725,7 +7725,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 
 		off = le64_to_cpu(zero_data->FileOffset);
 		bfz = le64_to_cpu(zero_data->BeyondFinalZero);
-		if (off > bfz) {
+		if (off < 0 || bfz < 0 || off > bfz) {
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.39.2



