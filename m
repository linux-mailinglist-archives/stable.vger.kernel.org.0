Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7362F79BA
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733294AbhAOMkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:40:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733202AbhAOMkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:40:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F0DE207C4;
        Fri, 15 Jan 2021 12:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714377;
        bh=yBGJTL1JCJnPTAXyOVlrRpt11JkqBiPs/MMF3Jxxkig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FuVgStkH5MKL3ZSTwGyP6JQM0eH/7DruI9xn06WkT5N/w5G622fh16XU1MWQiDy69
         D7Uo0NUkpLajgfkKXGjL63jkhz1O0TqhIjjF+m+AlSQ83OLgu451CqfurL+UbKbWcV
         2Scqm+fyQAuGRPpNjDhoX22ryMyBLOZRL1HTV6TM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 101/103] regmap: debugfs: Fix a reversed if statement in regmap_debugfs_init()
Date:   Fri, 15 Jan 2021 13:28:34 +0100
Message-Id: <20210115122010.887166659@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit f6bcb4c7f366905b66ce8ffca7190118244bb642 upstream.

This code will leak "map->debugfs_name" because the if statement is
reversed so it only frees NULL pointers instead of non-NULL.  In
fact the if statement is not required and should just be removed
because kfree() accepts NULL pointers.

Fixes: cffa4b2122f5 ("regmap: debugfs: Fix a memory leak when calling regmap_attach_dev")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/X/RQpfAwRdLg0GqQ@mwanda
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regmap-debugfs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -594,9 +594,7 @@ void regmap_debugfs_init(struct regmap *
 	}
 
 	if (!strcmp(name, "dummy")) {
-		if (!map->debugfs_name)
-			kfree(map->debugfs_name);
-
+		kfree(map->debugfs_name);
 		map->debugfs_name = kasprintf(GFP_KERNEL, "dummy%d",
 						dummy_index);
 		if (!map->debugfs_name)


