Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDF31579BF
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgBJNRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:17:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728982AbgBJMh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:59 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21EC32080C;
        Mon, 10 Feb 2020 12:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338279;
        bh=u0YOsKZVY/LHSnq59xIWYeeYGlOVdfZMYb2/w87UfLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vXBcO7BmxsMAwUTdwfhQDmRKldXIOHhmLR8nJQXe3h11f8qI7p1Y/sAPx0DAwWnGd
         a0TEHVUdtm5XPM7uFwMCIMEkddfCGTkYHF6iwy37a8VKmnp1IvVb93At1v+Kqvih4O
         g6s1bylaQLmoN8Qa+hLIfBP4Npwcj0h2z0T/VghM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Vasily Averin <vvs@virtuozzo.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 168/309] jbd2_seq_info_next should increase position index
Date:   Mon, 10 Feb 2020 04:32:04 -0800
Message-Id: <20200210122422.465132347@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit 1a8e9cf40c9a6a2e40b1e924b13ed303aeea4418 upstream.

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

Script below generates endless output
 $ q=;while read -r r;do echo "$((++q)) $r";done </proc/fs/jbd2/DEV/info

https://bugzilla.kernel.org/show_bug.cgi?id=206283

Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
Cc: stable@kernel.org
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/d13805e5-695e-8ac3-b678-26ca2313629f@virtuozzo.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/journal.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -981,6 +981,7 @@ static void *jbd2_seq_info_start(struct
 
 static void *jbd2_seq_info_next(struct seq_file *seq, void *v, loff_t *pos)
 {
+	(*pos)++;
 	return NULL;
 }
 


