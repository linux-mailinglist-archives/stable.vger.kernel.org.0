Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD231FB844
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732803AbgFPPyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733014AbgFPPyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:54:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E54721527;
        Tue, 16 Jun 2020 15:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322884;
        bh=L+ZIDbk7gGh2d8y06TrWjfNNB4BOtBVD11yTKaLw7C0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nf0CsbjUrp8oikgkxoYvsi6MUaqkst1KCZym0OrMD3+XOmVhBPyd8L6Sscn8UVmyM
         kvj9HyIQHOMp1vsBjmN0gouW+FRObdHsVRrnyxaKBK/8PKgLUV5uqx2GfFKFGLvjJe
         Ro9gTM1DKGue4MH4uRSu8KFFLokVKFqf/OfHtNvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hillf Danton <hdanton@sina.com>,
        syzbot+bfdd4a2f07be52351350@syzkaller.appspotmail.com,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 5.6 142/161] Smack: slab-out-of-bounds in vsscanf
Date:   Tue, 16 Jun 2020 17:35:32 +0200
Message-Id: <20200616153113.123932358@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

commit 84e99e58e8d1e26f04c097f4266e431a33987f36 upstream.

Add barrier to soob. Return -EOVERFLOW if the buffer
is exceeded.

Suggested-by: Hillf Danton <hdanton@sina.com>
Reported-by: syzbot+bfdd4a2f07be52351350@syzkaller.appspotmail.com
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/smack/smackfs.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -878,11 +878,21 @@ static ssize_t smk_set_cipso(struct file
 	else
 		rule += strlen(skp->smk_known) + 1;
 
+	if (rule > data + count) {
+		rc = -EOVERFLOW;
+		goto out;
+	}
+
 	ret = sscanf(rule, "%d", &maplevel);
 	if (ret != 1 || maplevel > SMACK_CIPSO_MAXLEVEL)
 		goto out;
 
 	rule += SMK_DIGITLEN;
+	if (rule > data + count) {
+		rc = -EOVERFLOW;
+		goto out;
+	}
+
 	ret = sscanf(rule, "%d", &catlen);
 	if (ret != 1 || catlen > SMACK_CIPSO_MAXCATNUM)
 		goto out;


