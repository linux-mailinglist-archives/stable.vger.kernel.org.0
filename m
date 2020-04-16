Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F88C1ACC2D
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442839AbgDPP4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895858AbgDPN2s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:28:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E810321D93;
        Thu, 16 Apr 2020 13:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043727;
        bh=FISnIMAk538PrUDM5Z16u1+l0BTcLxHxMzOCkMtfLFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P45VwAx2viX0BBMQl/Ntx7aJJ+vfJK0zpwVA3S+qLvoQqlcbbpFq+foJnA6DnbXu/
         uLBaQXrTvQjbDutzfQ/LCC4AwHwC32cizq54Qc3Lt+uO2fC7pnAtE+k9pZx4Ps8BMB
         bPRncjP3w9d2o0QS+Vrg/zzwCQOvFISQ/YBBuhAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.19 073/146] pstore: pstore_ftrace_seq_next should increase position index
Date:   Thu, 16 Apr 2020 15:23:34 +0200
Message-Id: <20200416131252.938450061@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit 6c871b7314dde9ab64f20de8f5aa3d01be4518e8 upstream.

In Aug 2018 NeilBrown noticed
commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
"Some ->next functions do not increment *pos when they return NULL...
Note that such ->next functions are buggy and should be fixed.
A simple demonstration is

 dd if=/proc/swaps bs=1000 skip=1

Choose any block size larger than the size of /proc/swaps. This will
always show the whole last line of /proc/swaps"

/proc/swaps output was fixed recently, however there are lot of other
affected files, and one of them is related to pstore subsystem.

If .next function does not change position index, following .show function
will repeat output related to current position index.

There are at least 2 related problems:
- read after lseek beyond end of file, described above by NeilBrown
  "dd if=<AFFECTED_FILE> bs=1000 skip=1" will generate whole last list
- read after lseek on in middle of last line will output expected rest of
  last line but then repeat whole last line once again.

If .show() function generates multy-line output (like
pstore_ftrace_seq_show() does ?) following bash script cycles endlessly

 $ q=;while read -r r;do echo "$((++q)) $r";done < AFFECTED_FILE

Unfortunately I'm not familiar enough to pstore subsystem and was unable
to find affected pstore-related file on my test node.

If .next function does not change position index, following .show function
will repeat output related to current position index.

Cc: stable@vger.kernel.org
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Link: https://lore.kernel.org/r/4e49830d-4c88-0171-ee24-1ee540028dad@virtuozzo.com
[kees: with robustness tweak from Joel Fernandes <joelaf@google.com>]
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pstore/inode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -99,11 +99,11 @@ static void *pstore_ftrace_seq_next(stru
 	struct pstore_private *ps = s->private;
 	struct pstore_ftrace_seq_data *data = v;
 
+	(*pos)++;
 	data->off += REC_SIZE;
 	if (data->off + REC_SIZE > ps->total_size)
 		return NULL;
 
-	(*pos)++;
 	return data;
 }
 
@@ -113,6 +113,9 @@ static int pstore_ftrace_seq_show(struct
 	struct pstore_ftrace_seq_data *data = v;
 	struct pstore_ftrace_record *rec;
 
+	if (!data)
+		return 0;
+
 	rec = (struct pstore_ftrace_record *)(ps->record->buf + data->off);
 
 	seq_printf(s, "CPU:%d ts:%llu %08lx  %08lx  %pf <- %pF\n",


