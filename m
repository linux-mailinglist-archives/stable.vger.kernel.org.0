Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E60F2EA57
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 03:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfE3Bql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 21:46:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbfE3Bql (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 21:46:41 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 67627309264D;
        Thu, 30 May 2019 01:46:40 +0000 (UTC)
Received: from [10.72.12.105] (ovpn-12-105.pek2.redhat.com [10.72.12.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7ECC519C70;
        Thu, 30 May 2019 01:46:37 +0000 (UTC)
Subject: Re: [PATCH 8/8] ceph: hold i_ceph_lock when removing caps for freeing
 inode
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com, stable@vger.kernel.org
References: <20190523080646.19632-8-zyan@redhat.com>
 <20190529131452.43F372081C@mail.kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <1fb32a0f-545c-2ace-3dcd-8df6ca9d32e6@redhat.com>
Date:   Thu, 30 May 2019 09:46:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190529131452.43F372081C@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 30 May 2019 01:46:40 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/29/19 9:14 PM, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.1.4, v5.0.18, v4.19.45, v4.14.121, v4.9.178, v4.4.180, v3.18.140.
> 
> v5.1.4: Build OK!
> v5.0.18: Failed to apply! Possible dependencies:
>      e3ec8d6898f71 ("ceph: send cap releases more aggressively")
> 
> v4.19.45: Failed to apply! Possible dependencies:
>      e3ec8d6898f71 ("ceph: send cap releases more aggressively")
> 
> v4.14.121: Failed to apply! Possible dependencies:
>      a1c6b8358171c ("ceph: define argument structure for handle_cap_grant")
>      a57d9064e4ee4 ("ceph: flush pending works before shutdown super")
>      e3ec8d6898f71 ("ceph: send cap releases more aggressively")
> 
> v4.9.178: Failed to apply! Possible dependencies:
>      a1c6b8358171c ("ceph: define argument structure for handle_cap_grant")
>      a57d9064e4ee4 ("ceph: flush pending works before shutdown super")
>      e3ec8d6898f71 ("ceph: send cap releases more aggressively")
> 
> v4.4.180: Failed to apply! Possible dependencies:
>      13d1ad16d05ee ("libceph: move message allocation out of ceph_osdc_alloc_request()")
>      34b759b4a22b0 ("ceph: kill ceph_empty_snapc")
>      3f1af42ad0fad ("libceph: enable large, variable-sized OSD requests")
>      5be0389dac662 ("ceph: re-send AIO write request when getting -EOLDSNAP error")
>      7627151ea30bc ("libceph: define new ceph_file_layout structure")
>      779fe0fb8e188 ("ceph: rados pool namespace support")
>      922dab6134178 ("libceph, rbd: ceph_osd_linger_request, watch/notify v2")
>      a1c6b8358171c ("ceph: define argument structure for handle_cap_grant")
>      ae458f5a171ba ("libceph: make r_request msg_size calculation clearer")
>      c41d13a31fefe ("rbd: use header_oid instead of header_name")
>      c8fe9b17d055f ("ceph: Asynchronous IO support")
>      d30291b985d18 ("libceph: variable-sized ceph_object_id")
>      e3ec8d6898f71 ("ceph: send cap releases more aggressively")
> 
> v3.18.140: Failed to apply! Possible dependencies:
>      10183a69551f7 ("ceph: check OSD caps before read/write")
>      28127bdd2f843 ("ceph: convert inline data to normal data before data write")
>      31c542a199d79 ("ceph: add inline data to pagecache")
>      5be0389dac662 ("ceph: re-send AIO write request when getting -EOLDSNAP error")
>      70db4f3629b34 ("ceph: introduce a new inode flag indicating if cached dentries are ordered")
>      745a8e3bccbc6 ("ceph: don't pre-allocate space for cap release messages")
>      7627151ea30bc ("libceph: define new ceph_file_layout structure")
>      779fe0fb8e188 ("ceph: rados pool namespace support")
>      83701246aee8f ("ceph: sync read inline data")
>      a1c6b8358171c ("ceph: define argument structure for handle_cap_grant")
>      affbc19a68f99 ("ceph: make sure syncfs flushes all cap snaps")
>      c8fe9b17d055f ("ceph: Asynchronous IO support")
>      d30291b985d18 ("libceph: variable-sized ceph_object_id")
>      d3383a8e37f80 ("ceph: avoid block operation when !TASK_RUNNING (ceph_mdsc_sync)")
>      e3ec8d6898f71 ("ceph: send cap releases more aggressively")
>      e96a650a8174e ("ceph, rbd: delete unnecessary checks before two function calls")
> 
> 
> How should we proceed with this patch?
> 

please use following patch for old kernels

Regards
Yan, Zheng

---
 From 55937416f12e096621b06ada7554cacb89d06e97 Mon Sep 17 00:00:00 2001
From: "Yan, Zheng" <zyan@redhat.com>
Date: Thu, 23 May 2019 11:01:37 +0800
Subject: [PATCH] ceph: hold i_ceph_lock when removing caps for freeing inode

ceph_d_revalidate(, LOOKUP_RCU) may call __ceph_caps_issued_mask()
on a freeing inode.

Cc: stable@vger.kernel.org
Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
---
  fs/ceph/caps.c | 7 +++++--
  1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index ff5d32cf9578..0fb4e919cdce 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1119,20 +1119,23 @@ static int send_cap_msg(struct cap_msg_args *arg)
  }

  /*
- * Queue cap releases when an inode is dropped from our cache.  Since
- * inode is about to be destroyed, there is no need for i_ceph_lock.
+ * Queue cap releases when an inode is dropped from our cache.
   */
  void ceph_queue_caps_release(struct inode *inode)
  {
  	struct ceph_inode_info *ci = ceph_inode(inode);
  	struct rb_node *p;

+	/* lock i_ceph_lock, because ceph_d_revalidate(..., LOOKUP_RCU)
+	 * may call __ceph_caps_issued_mask() on a freeing inode. */
+	spin_lock(&ci->i_ceph_lock);
  	p = rb_first(&ci->i_caps);
  	while (p) {
  		struct ceph_cap *cap = rb_entry(p, struct ceph_cap, ci_node);
  		p = rb_next(p);
  		__ceph_remove_cap(cap, true);
  	}
+	spin_unlock(&ci->i_ceph_lock);
  }

  /*
-- 
2.17.2





> --
> Thanks,
> Sasha
> 


