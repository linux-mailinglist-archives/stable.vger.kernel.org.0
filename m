Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CECA715778E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbgBJMkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729803AbgBJMkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:49 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEB7320661;
        Mon, 10 Feb 2020 12:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338448;
        bh=8HSn47iVmVuHK5R6HJ9DPCtyktsjn3EOBpK6AgA2IB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OF/9f8hHWMkCzGo1FfqkPnbjFvqUyzSCyx5GDoqYaJfyK80vNHGJckrgUWnYsR6cI
         AqM2DqFuLXhAR5hrVOt0b64+g7n0h3DFDCfMWqFnbL/8evvF6El/e3G8jtJlDQ9Aqj
         zQfHyB/POSY3RxTWtmziXtSuvdN8ewwkBZvLf/Ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Vasily Averin <vvs@virtuozzo.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.5 192/367] jbd2_seq_info_next should increase position index
Date:   Mon, 10 Feb 2020 04:31:45 -0800
Message-Id: <20200210122442.319188014@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
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
@@ -982,6 +982,7 @@ static void *jbd2_seq_info_start(struct
 
 static void *jbd2_seq_info_next(struct seq_file *seq, void *v, loff_t *pos)
 {
+	(*pos)++;
 	return NULL;
 }
 


