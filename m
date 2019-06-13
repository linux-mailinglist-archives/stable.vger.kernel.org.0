Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D412E44F21
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 00:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbfFMWax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 18:30:53 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40763 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfFMWaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 18:30:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so126627pfp.7;
        Thu, 13 Jun 2019 15:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=le87mSroNc/vpZ1PXB7D9b7oXP9bRIOE/1No2nrz140=;
        b=TcNfVaI7zCKBSfPScGJNIbpJxSZMkEGhfWZEvUL+iAPHzoim0WMMPifT02p1UMxqqJ
         Nfk7NxYIuorNrCC/+A4aDXTVhvfAMXnicEKOQay0xtQayKkKPxxsg9F6Lolf1x6YMmQD
         KnGOoP7L6tfcW3x2+i5l31yhe07mc9c1FNaYX6JC/dQ+h+yIXIkaGkxH1q4eAGoQLb69
         NhhAqkIOn+H1/H0O+SsmXYGSN6to3fdZ/78WCSJkpx3+lHw1p3G39B3EiemW/D7fW4c+
         UmA885xXs9ZEzMcGGsEiR5PWaoC07HZ63WfPntuz+sXaxrA2oH35tB2PpEbCXAqqbPpD
         YP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=le87mSroNc/vpZ1PXB7D9b7oXP9bRIOE/1No2nrz140=;
        b=rd8pyvEbdx1ClTjxBEWqC7TvNto7jhNQ2ZhdcUgcNGSleSCKrvotpUpnJcLz+VeQZ9
         eHJ9UrFarHeBk59T8ivgEeO4JHtnGrSn/bqCO/duevaeBG/HZoPfVtRXD2TKjWhUn/Bz
         HBtqL2kdwvTy60BV4b7wHGOpX749gaIXAOLHgy6QdVDEC4GsSNyhXYBlopooXs1YlNa5
         UOCQcYYbuizVx0JHgeE/y2TxoIiVlS3CtlAnY1MRFvWctH1i4hJBjhSPyO58qt7y4QsV
         vi8Jhygg1VI1ObSukfe+ulTyGQK21tJKqA2uvBodoncicnDASFCjzNuk1Zwx4Z7M0BWb
         kVNA==
X-Gm-Message-State: APjAAAWzBXu8ZXlewSvCQVC6ZZ3Ar9wvbfK+qPHnUEg8qeRHohpFEtD+
        m2PpLOIqm8X4n7kQOSBVUpHBYJhy
X-Google-Smtp-Source: APXvYqw4UvG2QfxpxlErOC18JBYhV4p5wHAymu+oqJ3TOV56Pu9bzZR+wv9jIIHxuWMpe9E0shGh+w==
X-Received: by 2002:a63:511b:: with SMTP id f27mr16922684pgb.135.1560465051357;
        Thu, 13 Jun 2019 15:30:51 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::2:9d14])
        by smtp.gmail.com with ESMTPSA id g5sm785427pfm.54.2019.06.13.15.30.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 15:30:50 -0700 (PDT)
From:   Tejun Heo <tj@kernel.org>
To:     axboe@kernel.dk, jbacik@fb.com
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        kernel-team@fb.com, dennis@kernel.org, jack@suse.cz,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/5] blkcg: update blkcg_print_stat() to handle larger outputs
Date:   Thu, 13 Jun 2019 15:30:38 -0700
Message-Id: <20190613223041.606735-3-tj@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190613223041.606735-1-tj@kernel.org>
References: <20190613223041.606735-1-tj@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Depending on the number of devices, blkcg stats can go over the
default seqfile buf size.  seqfile normally retries with a larger
buffer but since the ->pd_stat() addition, blkcg_print_stat() doesn't
tell seqfile that overflow has happened and the output gets printed
truncated.  Fix it by calling seq_commit() w/ -1 on possible
overflows.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 903d23f0a354 ("blk-cgroup: allow controllers to output their own stats")
Cc: stable@vger.kernel.org # v4.19+
Cc: Josef Bacik <jbacik@fb.com>
---
 block/blk-cgroup.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1f7127b03490..e4715b35d42c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1006,8 +1006,12 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 		}
 next:
 		if (has_stats) {
-			off += scnprintf(buf+off, size-off, "\n");
-			seq_commit(sf, off);
+			if (off < size - 1) {
+				off += scnprintf(buf+off, size-off, "\n");
+				seq_commit(sf, off);
+			} else {
+				seq_commit(sf, -1);
+			}
 		}
 	}
 
-- 
2.17.1

