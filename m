Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04945126AA3
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbfLSSta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:49:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729797AbfLSSt3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:49:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94B6B24683;
        Thu, 19 Dec 2019 18:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781369;
        bh=tBE4vl7OXzkNVp8t5xjxldR3LN+ffg1MDf1XTpuRigs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3n3NmD55n3SvKWcCpCBsSekbxQKftBYRosF+LCORG/c4dRXI8MzlJRcSkU2aE4x8
         1W1ujBQrP2ZGFlCuyx8Xu0DXrdgE+llt/f8HuR7/TbWxXCgFvwejK81yrJj7nFH4yl
         gjAZYuAWFicBlkqN+tfSTShe/UBsJyE/0IlmgFvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 4.9 193/199] dma-buf: Fix memory leak in sync_file_merge()
Date:   Thu, 19 Dec 2019 19:34:35 +0100
Message-Id: <20191219183226.448734201@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit 6645d42d79d33e8a9fe262660a75d5f4556bbea9 upstream.

In the implementation of sync_file_merge() the allocated sync_file is
leaked if number of fences overflows. Release sync_file by goto err.

Fixes: a02b9dc90d84 ("dma-buf/sync_file: refactor fence storage in struct sync_file")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20191122220957.30427-1-navid.emamdoost@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma-buf/sync_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma-buf/sync_file.c
+++ b/drivers/dma-buf/sync_file.c
@@ -204,7 +204,7 @@ static struct sync_file *sync_file_merge
 	a_fences = get_fences(a, &a_num_fences);
 	b_fences = get_fences(b, &b_num_fences);
 	if (a_num_fences > INT_MAX - b_num_fences)
-		return NULL;
+		goto err;
 
 	num_fences = a_num_fences + b_num_fences;
 


