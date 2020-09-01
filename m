Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354F1259776
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731915AbgIAQOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731199AbgIAPfS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:35:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 919B720866;
        Tue,  1 Sep 2020 15:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974511;
        bh=qWkM3Om2LckEUxIo++nIEQvs9JMWHngR19nimbA97dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQh+n6onWRvec9e0ddkHMZNcVaY1cMPuOdD7fdMt2jJulqqS+3/FfhtOQ2xrcDzvU
         HMAqg3MDPQEV03KXxNHoB4FGJl6jYtlsXog5rww9tazh3itI8Deu+Y1v4KFyNlMO1c
         mlGRm/g5evZAUL4xh2LW65mac0V00euKx0aKIHP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Maennich <maennich@google.com>
Subject: [PATCH 5.4 205/214] kheaders: remove unneeded cat command piped to head / tail
Date:   Tue,  1 Sep 2020 17:11:25 +0200
Message-Id: <20200901151002.753802071@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 9a066357184485784f782719093ff804d05b85db upstream.

The 'head' and 'tail' commands can take a file path directly.
So, you do not need to run 'cat'.

  cat kernel/kheaders.md5 | head -1

... is equivalent to:

  head -1 kernel/kheaders.md5

and the latter saves forking one process.

While I was here, I replaced 'head -1' with 'head -n 1'.

I also replaced '==' with '=' since we do not have a good reason to
use the bashism.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Matthias Maennich <maennich@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/gen_kheaders.sh |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -41,10 +41,10 @@ obj_files_md5="$(find $dir_list -name "*
 this_file_md5="$(ls -l $sfile | md5sum | cut -d ' ' -f1)"
 if [ -f $tarfile ]; then tarfile_md5="$(md5sum $tarfile | cut -d ' ' -f1)"; fi
 if [ -f kernel/kheaders.md5 ] &&
-	[ "$(cat kernel/kheaders.md5|head -1)" == "$src_files_md5" ] &&
-	[ "$(cat kernel/kheaders.md5|head -2|tail -1)" == "$obj_files_md5" ] &&
-	[ "$(cat kernel/kheaders.md5|head -3|tail -1)" == "$this_file_md5" ] &&
-	[ "$(cat kernel/kheaders.md5|tail -1)" == "$tarfile_md5" ]; then
+	[ "$(head -n 1 kernel/kheaders.md5)" = "$src_files_md5" ] &&
+	[ "$(head -n 2 kernel/kheaders.md5 | tail -n 1)" = "$obj_files_md5" ] &&
+	[ "$(head -n 3 kernel/kheaders.md5 | tail -n 1)" = "$this_file_md5" ] &&
+	[ "$(tail -n 1 kernel/kheaders.md5)" = "$tarfile_md5" ]; then
 		exit
 fi
 


