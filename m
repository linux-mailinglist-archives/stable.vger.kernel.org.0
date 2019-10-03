Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF5CCAC92
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388074AbfJCQMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732757AbfJCQMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:12:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3968220700;
        Thu,  3 Oct 2019 16:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119152;
        bh=yHF9RoZHB6Qm3RCjepEVe+GJFwIebmGSDxiefTu0FjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snZDZmPMNnnNruuj3T0rk0XvwbGDFXOtpWy/LM8cH2gZ3Bq93ltSIHDFSM2S1I3E9
         6tD2oTQYaGIvbhrqo9sEZwvloACNlXKF2rhikOSMGz4shAojZJjy9I/Spu1+dqvzoc
         dy4E0g5r/Obt6Jb8FZ4z6FhmEh3Bn2AUrE6R4370=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joonwon Kang <kjw1627@gmail.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.14 145/185] randstruct: Check member structs in is_pure_ops_struct()
Date:   Thu,  3 Oct 2019 17:53:43 +0200
Message-Id: <20191003154511.237260444@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joonwon Kang <kjw1627@gmail.com>

commit 60f2c82ed20bde57c362e66f796cf9e0e38a6dbb upstream.

While no uses in the kernel triggered this case, it was possible to have
a false negative where a struct contains other structs which contain only
function pointers because of unreachable code in is_pure_ops_struct().

Signed-off-by: Joonwon Kang <kjw1627@gmail.com>
Link: https://lore.kernel.org/r/20190727155841.GA13586@host
Fixes: 313dd1b62921 ("gcc-plugins: Add the randstruct plugin")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/gcc-plugins/randomize_layout_plugin.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -443,13 +443,13 @@ static int is_pure_ops_struct(const_tree
 		if (node == fieldtype)
 			continue;
 
-		if (!is_fptr(fieldtype))
-			return 0;
-
-		if (code != RECORD_TYPE && code != UNION_TYPE)
+		if (code == RECORD_TYPE || code == UNION_TYPE) {
+			if (!is_pure_ops_struct(fieldtype))
+				return 0;
 			continue;
+		}
 
-		if (!is_pure_ops_struct(fieldtype))
+		if (!is_fptr(fieldtype))
 			return 0;
 	}
 


