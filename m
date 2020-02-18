Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 498861631DA
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgBRUDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:03:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728841AbgBRUDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:03:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF7A024673;
        Tue, 18 Feb 2020 20:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056184;
        bh=MKwR1Ey5s9/JR9K6iEYpEMGtlvVkD6LC+UA956/m7G8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nz9f8kCX89rx4dpmnw27D4f4yxSaJReZ7dMoSXh2s3pyhvNUoa8w9GDRS2DVSaAi0
         spscffHOzRAdUFfIYYvJoEYTpS4Rm00Zq8eYpSwiadtNyARkcsRidZi6f6ph208qOZ
         Cp9V6x3cnWy5McDGpdWTeXmLJfj7BcOVrIixqwfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Pavlu <petr.pavlu@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.5 66/80] cifs: fix mount option display for sec=krb5i
Date:   Tue, 18 Feb 2020 20:55:27 +0100
Message-Id: <20200218190438.315043569@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Pavlu <petr.pavlu@suse.com>

commit 3f6166aaf19902f2f3124b5426405e292e8974dd upstream.

Fix display for sec=krb5i which was wrongly interleaved by cruid,
resulting in string "sec=krb5,cruid=<...>i" instead of
"sec=krb5i,cruid=<...>".

Fixes: 96281b9e46eb ("smb3: for kerberos mounts display the credential uid used")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsfs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -414,7 +414,7 @@ cifs_show_security(struct seq_file *s, s
 		seq_puts(s, "ntlm");
 		break;
 	case Kerberos:
-		seq_printf(s, "krb5,cruid=%u", from_kuid_munged(&init_user_ns,ses->cred_uid));
+		seq_puts(s, "krb5");
 		break;
 	case RawNTLMSSP:
 		seq_puts(s, "ntlmssp");
@@ -427,6 +427,10 @@ cifs_show_security(struct seq_file *s, s
 
 	if (ses->sign)
 		seq_puts(s, "i");
+
+	if (ses->sectype == Kerberos)
+		seq_printf(s, ",cruid=%u",
+			   from_kuid_munged(&init_user_ns, ses->cred_uid));
 }
 
 static void


