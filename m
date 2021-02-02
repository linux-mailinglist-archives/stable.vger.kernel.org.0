Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C18B30C077
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbhBBN6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:58:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:42464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233371AbhBBN4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:56:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9A2F64FE1;
        Tue,  2 Feb 2021 13:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273527;
        bh=WfRDzh4AJiM/mJTdUa1rnNMF78ojs4v9BhHYuu1qvr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpYhRAgbJpTLvjS15yQeUuyRlBUIvwSVNC2JPPv0HjDEbhJ561UMNSOCFgUJc/aKk
         bYUsvWm/e+sMKm1xTlMzKFUYSW0KMFwFE+bfVqlwJx74SKSqNJB50cChFZM77r3GlI
         ArCx1x8wnK1Da4S9sIM5SAWD4QlHAUIA4/cCH1U8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 138/142] ASoC: topology: Fix memory corruption in soc_tplg_denum_create_values()
Date:   Tue,  2 Feb 2021 14:38:21 +0100
Message-Id: <20210202133003.384069100@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 543466ef3571069b8eb13a8ff7c7cfc8d8a75c43 upstream.

The allocation uses sizeof(u32) when it should use sizeof(unsigned long)
so it leads to memory corruption later in the function when the data is
initialized.

Fixes: 5aebe7c7f9c2 ("ASoC: topology: fix endianness issues")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YAf+8QZoOv+ct526@mwanda
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -987,7 +987,7 @@ static int soc_tplg_denum_create_values(
 		return -EINVAL;
 
 	se->dobj.control.dvalues = kzalloc(le32_to_cpu(ec->items) *
-					   sizeof(u32),
+					   sizeof(*se->dobj.control.dvalues),
 					   GFP_KERNEL);
 	if (!se->dobj.control.dvalues)
 		return -ENOMEM;


