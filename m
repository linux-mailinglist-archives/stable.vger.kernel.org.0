Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9171A1A8C8B
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 22:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633205AbgDNUdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 16:33:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59412 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2633203AbgDNUda (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 16:33:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586896409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=KwTOC5onNXJuxN2tXzBuJ3tclXWEJTwV06ZLB9D3qTQ=;
        b=J0OxfsnGz3zOgiGMJsHEyPT0uQG/r8ngo06436StjO0Q1Xhu96pktT1GMVCXXmkfWB8ZEh
        b97jQFLP7GBMVf6wzNKlXisgJtpQo2/2blMDkJwoA42W3X5kXBAwKeRwZs20FVJvH2BJes
        dI2F7eBCpZz8h2nuGp4qV+xKvmfskcc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-PUQ0StVLN8yTR-bYNrMKXQ-1; Tue, 14 Apr 2020 16:33:20 -0400
X-MC-Unique: PUQ0StVLN8yTR-bYNrMKXQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0E25149C0;
        Tue, 14 Apr 2020 20:33:18 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-129.rdu2.redhat.com [10.10.113.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BA60126510;
        Tue, 14 Apr 2020 20:33:17 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] keys: Fix proc_keys_next to increase position index
From:   David Howells <dhowells@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        dhowells@redhat.com, jarkko.sakkinen@linux.intel.com,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 14 Apr 2020 21:33:16 +0100
Message-ID: <158689639664.3925765.4549426529245164675.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

If seq_file .next function does not change position index,
read after some lseek can generate unexpected output:

$ dd if=/proc/keys bs=1  # full usual output
0f6bfdf5 I--Q---     2 perm 3f010000  1000  1000 user      4af2f79ab8848d0a: 740
1fb91b32 I--Q---     3 perm 1f3f0000  1000 65534 keyring   _uid.1000: 2
27589480 I--Q---     1 perm 0b0b0000     0     0 user      invocation_id: 16
2f33ab67 I--Q---   152 perm 3f030000     0     0 keyring   _ses: 2
33f1d8fa I--Q---     4 perm 3f030000  1000  1000 keyring   _ses: 1
3d427fda I--Q---     2 perm 3f010000  1000  1000 user      69ec44aec7678e5a: 740
3ead4096 I--Q---     1 perm 1f3f0000  1000 65534 keyring   _uid_ses.1000: 1
521+0 records in
521+0 records out
521 bytes copied, 0,00123769 s, 421 kB/s

$ dd if=/proc/keys bs=500 skip=1  # read after lseek in middle of last line
dd: /proc/keys: cannot skip to specified offset
g   _uid_ses.1000: 1        <<<< end of last line
3ead4096 I--Q---     1 perm 1f3f0000  1000 65534 keyring   _uid_ses.1000: 1
   <<<< and whole last line again
0+1 records in
0+1 records out
97 bytes copied, 0,000135035 s, 718 kB/s

$ dd if=/proc/keys bs=1000 skip=1   # read after lseek beyond end of file
dd: /proc/keys: cannot skip to specified offset
3ead4096 I--Q---     1 perm 1f3f0000  1000 65534 keyring   _uid_ses.1000: 1
   <<<< generates last line
0+1 records in
0+1 records out
76 bytes copied, 0,000119981 s, 633 kB/s

See https://bugzilla.kernel.org/show_bug.cgi?id=206283

Cc: stable@vger.kernel.org
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/proc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/keys/proc.c b/security/keys/proc.c
index 415f3f1c2da0..d0cde6685627 100644
--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -139,6 +139,8 @@ static void *proc_keys_next(struct seq_file *p, void *v, loff_t *_pos)
 	n = key_serial_next(p, v);
 	if (n)
 		*_pos = key_node_serial(n);
+	else
+		(*_pos)++;
 	return n;
 }
 


