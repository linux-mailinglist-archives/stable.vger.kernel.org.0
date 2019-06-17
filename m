Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49A0D4946C
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfFQViN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728287AbfFQVSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:18:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E17842133F;
        Mon, 17 Jun 2019 21:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806334;
        bh=M3WtjkHNv4iTtky1f5EnerEPfoZTklWgPAO2tVoeFv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GU6+GZ8O+L6VKtnBvPuxxEnU/X+RQlqbU2Yj5oVmKWCDhPIEeDBMgll9H17W0Qoae
         Y8vxoBE7MWeTwaPD/skfegC+2fZplqanz6Ii7Q5pr1XVIYSuiAPAsHFCz+eCpTEDLi
         mqVFRhyqud1cRS4gFydwB8AzWwq5C17FJZo+Wgrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.1 017/115] selinux: log raw contexts as untrusted strings
Date:   Mon, 17 Jun 2019 23:08:37 +0200
Message-Id: <20190617210800.792335370@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit aff7ed4851680d0d28ad9f52cd2f99213e1371b2 upstream.

These strings may come from untrusted sources (e.g. file xattrs) so they
need to be properly escaped.

Reproducer:
    # setenforce 0
    # touch /tmp/test
    # setfattr -n security.selinux -v 'kuřecí řízek' /tmp/test
    # runcon system_u:system_r:sshd_t:s0 cat /tmp/test
    (look at the generated AVCs)

Actual result:
    type=AVC [...] trawcon=kuřecí řízek

Expected result:
    type=AVC [...] trawcon=6B75C5996563C3AD20C599C3AD7A656B

Fixes: fede148324c3 ("selinux: log invalid contexts in AVCs")
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Acked-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/avc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -739,14 +739,20 @@ static void avc_audit_post_callback(stru
 	rc = security_sid_to_context_inval(sad->state, sad->ssid, &scontext,
 					   &scontext_len);
 	if (!rc && scontext) {
-		audit_log_format(ab, " srawcon=%s", scontext);
+		if (scontext_len && scontext[scontext_len - 1] == '\0')
+			scontext_len--;
+		audit_log_format(ab, " srawcon=");
+		audit_log_n_untrustedstring(ab, scontext, scontext_len);
 		kfree(scontext);
 	}
 
 	rc = security_sid_to_context_inval(sad->state, sad->tsid, &scontext,
 					   &scontext_len);
 	if (!rc && scontext) {
-		audit_log_format(ab, " trawcon=%s", scontext);
+		if (scontext_len && scontext[scontext_len - 1] == '\0')
+			scontext_len--;
+		audit_log_format(ab, " trawcon=");
+		audit_log_n_untrustedstring(ab, scontext, scontext_len);
 		kfree(scontext);
 	}
 }


