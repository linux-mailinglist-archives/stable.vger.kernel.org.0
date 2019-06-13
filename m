Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C818F44F22
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 00:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfFMWau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 18:30:50 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40756 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfFMWat (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 18:30:49 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so126533pfp.7;
        Thu, 13 Jun 2019 15:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U7FQmFFF1Z7fbd/otHz8+BUYJEJIQONwHFEy1+lWias=;
        b=ou8LjWlocAo0l+AbBD2K8zqOXdHKtUJiuOKET9r4w2rYN8FTmJm9/rkEcRYxxwarXU
         SEhyPscTnAzXgCFIJWK5iLd9z+cvsmGhefs5JnhaUZGL9BA8PHvNxLll/3vFK914D+aW
         YGV19T8nfi1N1oex58KP07rbT7j9pfn6UcpSyu47NmD8gMfAXs/OLD0dEbr+6KXZApfn
         9xJjEGAZFGRBbJsJHRclDWUgaQ8d47vAEY+fTE39qpMdFepfOyy/IMgrMnJnhI7qaIFX
         xazIFmZect8aSvQjduAHe4T3bW2Cigb1rVqdbJXzALIsWIPv5JtGZVMBqhXqNL8WfmBs
         zMAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=U7FQmFFF1Z7fbd/otHz8+BUYJEJIQONwHFEy1+lWias=;
        b=HlZiktsagTB1eqWmovDjAJoxYYvEzXWFwRbBzPA7txh9LohiA+BmWU6BYcfaLSOxDp
         1IZmCGB/9ytBQZaiIM7kPIYfHKOKfTtbFwevvcacEdShzphUMSXGXrM4/M0oH1xHF0Mx
         j562ZFTO0TpF+q4cVP1bzkpEqV1gMEZjjuoykJQ64VsFc2D88fa6Xz+B2eL2d8/P1HYs
         1UbjI983WY9/tvlmhav0t8jXNE3o4HNd1t5Hf2EnG75nZ73PcV7ZR/PH56fl4eMJsyJk
         n3XQz+HPz9fsSB/A4jWS0mWvC+FDv2vHBpOcQMmbviG+MY0L8vT8OCbYxXCYOqu4ch98
         kLJA==
X-Gm-Message-State: APjAAAXPRWg3z2hmT0c6FbucaIuivI0DIst+2l2DocwzjhEJLXvTDW3l
        LYrio054McDnamMFTnzh1wi+aCYK
X-Google-Smtp-Source: APXvYqzcZ+KeeCn26qjrgyY2X4mTd17aLheAHsEdaxp8KdwvnigyJg/XaRKDKq9XFJgvCS02qH5ksg==
X-Received: by 2002:a17:90a:d681:: with SMTP id x1mr7614682pju.13.1560465048467;
        Thu, 13 Jun 2019 15:30:48 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::2:9d14])
        by smtp.gmail.com with ESMTPSA id 5sm610910pfh.109.2019.06.13.15.30.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 15:30:47 -0700 (PDT)
From:   Tejun Heo <tj@kernel.org>
To:     axboe@kernel.dk, jbacik@fb.com
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        kernel-team@fb.com, dennis@kernel.org, jack@suse.cz,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/5] blk-iolatency: clear use_delay when io.latency is set to zero
Date:   Thu, 13 Jun 2019 15:30:37 -0700
Message-Id: <20190613223041.606735-2-tj@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190613223041.606735-1-tj@kernel.org>
References: <20190613223041.606735-1-tj@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If use_delay was non-zero when the latency target of a cgroup was set
to zero, it will stay stuck until io.latency is enabled on the cgroup
again.  This keeps readahead disabled for the cgroup impacting
performance negatively.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <jbacik@fb.com>
Fixes: d70675121546 ("block: introduce blk-iolatency io controller")
Cc: stable@vger.kernel.org # v4.19+
---
 block/blk-iolatency.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index d22e61bced86..17896bb3aaf2 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -778,8 +778,10 @@ static int iolatency_set_min_lat_nsec(struct blkcg_gq *blkg, u64 val)
 
 	if (!oldval && val)
 		return 1;
-	if (oldval && !val)
+	if (oldval && !val) {
+		blkcg_clear_delay(blkg);
 		return -1;
+	}
 	return 0;
 }
 
-- 
2.17.1

