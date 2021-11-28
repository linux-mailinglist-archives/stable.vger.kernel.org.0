Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7F94605E6
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 12:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhK1LlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 06:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhK1LjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 06:39:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E922CC061574
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 03:36:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63033B80CC8
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 11:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6899EC004E1;
        Sun, 28 Nov 2021 11:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638099362;
        bh=viOWD0DQrqrqWzfMHl0mU2SmBYf5MkcJ/k18WTwxZaU=;
        h=Subject:To:Cc:From:Date:From;
        b=CZb5ARXh2Kk+pKSjUT1HXOvEdFmhe3iF5WAW0egoun4tjZ4Tf6rLa1lrK0MPcMMGd
         EmLYJEa+5UKy5gPYTv52gYZhMpLm2QKVKMaLjPg1BSLeCq5yLj8OKDN0uWCmplxTCF
         y40Cr/ZQ5XKoV2mkibQ3nGfQyT1Pe8AXVRmAps2A=
Subject: FAILED: patch "[PATCH] ksmbd: Fix an error handling path in 'smb2_sess_setup()'" failed to apply to 5.15-stable tree
To:     christophe.jaillet@wanadoo.fr, linkinjeon@kernel.org,
        stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Nov 2021 12:35:59 +0100
Message-ID: <163809935956126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f8fbfd85f5c95fff477a7c19f576725945891d0c Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 7 Nov 2021 16:22:57 +0100
Subject: [PATCH] ksmbd: Fix an error handling path in 'smb2_sess_setup()'

All the error handling paths of 'smb2_sess_setup()' end to 'out_err'.

All but the new error handling path added by the commit given in the Fixes
tag below.

Fix this error handling path and branch to 'out_err' as well.

Fixes: 0d994cd482ee ("ksmbd: add buffer validation in session setup")
Cc: stable@vger.kernel.org # v5.15
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 121f8e8c70ac..7d2e8599dc27 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1697,8 +1697,10 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	negblob_off = le16_to_cpu(req->SecurityBufferOffset);
 	negblob_len = le16_to_cpu(req->SecurityBufferLength);
 	if (negblob_off < offsetof(struct smb2_sess_setup_req, Buffer) ||
-	    negblob_len < offsetof(struct negotiate_message, NegotiateFlags))
-		return -EINVAL;
+	    negblob_len < offsetof(struct negotiate_message, NegotiateFlags)) {
+		rc = -EINVAL;
+		goto out_err;
+	}
 
 	negblob = (struct negotiate_message *)((char *)&req->hdr.ProtocolId +
 			negblob_off);

