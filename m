Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 415BFA8ECB
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388342AbfIDSAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388339AbfIDSAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:00:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B0022CF7;
        Wed,  4 Sep 2019 18:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620004;
        bh=tFqCp16aNSWR277rTmCPSwFTD5kGdcp9QL3VQurlJrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jlG0GaoGKRkAH7kvhq77548WBk1NUWvpIUxLOjGlbZJYcWQ22MCYtoUETjPa6S4it
         IpbKtPzOmmGnzjXSopmp6ImpIIMjSvS0dJgGPtXFbyOrRa6Zv6mXIuIAYQg+930zvh
         PAzs3tPBTb8NHlnHb50AGFub9+LGtyJXHsGV5Ibo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ZhangXiaoxu <zhangxiaoxu5@huawei.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.9 38/83] dm space map metadata: fix missing store of apply_bops() return value
Date:   Wed,  4 Sep 2019 19:53:30 +0200
Message-Id: <20190904175307.224152559@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ZhangXiaoxu <zhangxiaoxu5@huawei.com>

commit ae148243d3f0816b37477106c05a2ec7d5f32614 upstream.

In commit 6096d91af0b6 ("dm space map metadata: fix occasional leak
of a metadata block on resize"), we refactor the commit logic to a new
function 'apply_bops'.  But when that logic was replaced in out() the
return value was not stored.  This may lead out() returning a wrong
value to the caller.

Fixes: 6096d91af0b6 ("dm space map metadata: fix occasional leak of a metadata block on resize")
Cc: stable@vger.kernel.org
Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/persistent-data/dm-space-map-metadata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -248,7 +248,7 @@ static int out(struct sm_metadata *smm)
 	}
 
 	if (smm->recursion_count == 1)
-		apply_bops(smm);
+		r = apply_bops(smm);
 
 	smm->recursion_count--;
 


