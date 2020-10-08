Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346762872FA
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 13:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbgJHLAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 07:00:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57890 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728797AbgJHLAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 07:00:19 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098B0E4P101656;
        Thu, 8 Oct 2020 11:00:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=tWPPbUC2AHoVJyZzDwnMDvWIZeZR9GC/fsnwWvFpj1U=;
 b=p8EQJRfN+TegsQxG+nr/2kVAznUcauLuHFPSkat2c3Nqd0+jZ4vCnHk1gJm0B+7A2yDk
 qZrWo4g6j+9udRWgKq4drpw2ZlF1Pui2Xdm97Oby8+Qie1YPErUJ2K+orDY3iA4VCZY6
 UUH7P6+KewLh+IOokdXQC6foXFZGhpXQ+o6SbA3oHSMYs4x88pMg7sCmGpEvNYjiZqTm
 ksbOV7/Cwexc4gs/5Od9SC+3RVQTQJKgVrHDYFN25CTF7mxF2a13uTzJbpKZVJckAQkF
 smEdddHvBUdSXwy8FF1y2GNWr+mVYLynU6ESxuO97pHwAYUkg5AABJ6QHd7epvladh5P 1w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33xetb75yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 11:00:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098AuESp188416;
        Thu, 8 Oct 2020 11:00:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33y380yvb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 11:00:12 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 098B0BQj011154;
        Thu, 8 Oct 2020 11:00:11 GMT
Received: from ltp.sg.oracle.com (/10.191.35.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 04:00:11 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wqu@suse.com, fdmanana@suse.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH stable-5.4 3/6] btrfs: volumes: Use more straightforward way to calculate map length
Date:   Thu,  8 Oct 2020 18:59:51 +0800
Message-Id: <b15e98a7c6129f8b5f0a7748061e93865bb944e1.1599750901.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1599750901.git.anand.jain@oracle.com>
References: <cover.1599750901.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080081
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 2d974619a77f106f3d1341686dea95c0eaad601f upstream.

The old code goes:

 	offset = logical - em->start;
	length = min_t(u64, em->len - offset, length);

Where @length calculation is dependent on offset, it can take reader
several more seconds to find it's just the same code as:

 	offset = logical - em->start;
	length = min_t(u64, em->start + em->len - logical, length);

Use above code to make the length calculate independent from other
variable, thus slightly increase the readability.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 196ddbcd2936..1dba45d43485 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5712,7 +5712,7 @@ static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
 	}
 
 	offset = logical - em->start;
-	length = min_t(u64, em->len - offset, length);
+	length = min_t(u64, em->start + em->len - logical, length);
 
 	stripe_len = map->stripe_len;
 	/*
-- 
2.25.1

