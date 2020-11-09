Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AD02ABA79
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387532AbgKINTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:19:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731904AbgKINTi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:19:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E46020663;
        Mon,  9 Nov 2020 13:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927977;
        bh=KWmQaJdU2iocIYH0eNyvWRoarripQ7D0c/jhctXP6ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ac7x8ORJqEt4Fmozpys2EJ+YoIOj/hDQxPRdwP2sh31rIkSw5HZ8kX+vnHIrVRGlK
         GLa3KX1ID5h5An2l5tIYfdNMABi5HHIVlWWRISGzm3kNWcBpzdGn1lrxw8XS2VqlT1
         wkNEm6i0h010JQfytCESlEOU/q46y64IMR/Ez8o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 085/133] blk-cgroup: Fix memleak on error path
Date:   Mon,  9 Nov 2020 13:55:47 +0100
Message-Id: <20201109125034.801043377@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 52abfcbd57eefdd54737fc8c2dc79d8f46d4a3e5 ]

If new_blkg allocation raced with blk_policy change and
blkg_lookup_check fails, new_blkg is leaked.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index c195365c98172..7b2df042220d4 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -654,6 +654,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		blkg = blkg_lookup_check(pos, pol, q);
 		if (IS_ERR(blkg)) {
 			ret = PTR_ERR(blkg);
+			blkg_free(new_blkg);
 			goto fail_unlock;
 		}
 
-- 
2.27.0



