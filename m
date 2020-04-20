Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C441B0B94
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgDTMoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:44:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgDTMoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:44:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59050206E9;
        Mon, 20 Apr 2020 12:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386669;
        bh=HaUo+E5NxLGCGdFw4NKrqAONKCA3eOeOzeVolfXxgx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ep1BQ2OU2ivW1d5Csa9hDl9r9nckAdulX6r3BQSPogrk0/0dsvYiVVoTEWqyREWvK
         axjMmv8SW7uXc0fCJExqc3GX+zdfDBkgDuzcFuZ8XEO20Sr2pfEDgxxOUVGk6uSzSg
         IsiGaMw08+bRBVhHdY2XqgMwemaKxAHe86zF3Nf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.6 49/71] keys: Fix proc_keys_next to increase position index
Date:   Mon, 20 Apr 2020 14:39:03 +0200
Message-Id: <20200420121519.138652082@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit 86d32f9a7c54ad74f4514d7fef7c847883207291 upstream.

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

But a read after lseek in middle of last line results in the partial
last line and then a repeat of the final line:

    $ dd if=/proc/keys bs=500 skip=1
    dd: /proc/keys: cannot skip to specified offset
    g   _uid_ses.1000: 1
    3ead4096 I--Q---     1 perm 1f3f0000  1000 65534 keyring   _uid_ses.1000: 1
    0+1 records in
    0+1 records out
    97 bytes copied, 0,000135035 s, 718 kB/s

and a read after lseek beyond end of file results in the last line being
shown:

    $ dd if=/proc/keys bs=1000 skip=1   # read after lseek beyond end of file
    dd: /proc/keys: cannot skip to specified offset
    3ead4096 I--Q---     1 perm 1f3f0000  1000 65534 keyring   _uid_ses.1000: 1
    0+1 records in
    0+1 records out
    76 bytes copied, 0,000119981 s, 633 kB/s

See https://bugzilla.kernel.org/show_bug.cgi?id=206283

Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/keys/proc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -139,6 +139,8 @@ static void *proc_keys_next(struct seq_f
 	n = key_serial_next(p, v);
 	if (n)
 		*_pos = key_node_serial(n);
+	else
+		(*_pos)++;
 	return n;
 }
 


