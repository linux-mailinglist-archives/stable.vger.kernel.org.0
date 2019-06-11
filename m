Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28D513C596
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 10:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404476AbfFKIHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 04:07:23 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33429 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404418AbfFKIHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 04:07:22 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so11908331wru.0
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 01:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WHWrvmaz/r/uPs6ClZNwktNqPw2BVBCjeEDlthzgcU8=;
        b=ThvCe97m9x3fNv5MMl2EmuFGDEcebNW349cEQ3vDVV5Kbrvq4m/SjQbdibdbYBHBbA
         HGhuEUFmox6uPpCZ8EfOPl+4xaJDs92XOobbS+LMGlwFXVpjJ8lTgDIYVN/NXbNkzx6g
         sR4aI2TttttQFflUqZPNdT38EQ/vTPuK7Qle1TjWXkjgwk/0ahzUWGShCKojS+qBWmrL
         peeQyIxKZZd7avtrs4fXOmjHCc73tmlDy6Hsf+dLI8Jyle9yoybZFjmPRAjcD5l6Q6kw
         h6plq3+ud9aNdZ6VTgTMJFezijBRSxPhoGUzs5FLa5oGPOts48Om+Bq+9d8yFW3gNIIz
         kH/g==
X-Gm-Message-State: APjAAAXb4ILEG8ONWtdLbJHD8IN79tABFE/wvJtv7mSgsCSQMY/rYNDi
        D9JPzUupYKStYAMsQDX8wqdsSA==
X-Google-Smtp-Source: APXvYqwJCH1RG30C5HPYM3/363CUgEAM/3wWHHRnQ6oWWiIQBXXHTJfBuRDit6IqiagJ6r3cK6D2dg==
X-Received: by 2002:adf:b643:: with SMTP id i3mr20919171wre.284.1560240441294;
        Tue, 11 Jun 2019 01:07:21 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h90sm29632411wrh.15.2019.06.11.01.07.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 01:07:20 -0700 (PDT)
From:   Ondrej Mosnacek <omosnace@redhat.com>
To:     selinux@vger.kernel.org, Paul Moore <paul@paul-moore.com>
Cc:     linux-audit@redhat.com, stable@vger.kernel.org
Subject: [PATCH] selinux: log raw contexts as untrusted strings
Date:   Tue, 11 Jun 2019 10:07:19 +0200
Message-Id: <20190611080719.28625-1-omosnace@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 security/selinux/avc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index 8346a4f7c5d7..a99be508f93d 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -739,14 +739,20 @@ static void avc_audit_post_callback(struct audit_buffer *ab, void *a)
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
-- 
2.20.1

