Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A2662211D
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 02:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiKIBCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 20:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiKIBCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 20:02:54 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054F457B59;
        Tue,  8 Nov 2022 17:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667955773; x=1699491773;
  h=from:to:cc:date:message-id:references:in-reply-to:
   mime-version:subject;
  bh=Gmj8piMn6bPu+TcxFjK2auW1OjVCZk7wLO4qGnf3zwA=;
  b=NI1qBOdyTYgupRv1wxRfqS8yPO1xIawBxMHAg9amHmRY/oGvQ+z/Sb72
   eBLESuS6Vv+sE7Hxn5TbKv5mpyTTD9dEuNCbLaxcdP8wdEHLTI2qu1ylZ
   L3wfw7XqrjBxhRhySuD316arEIkb97LhhB/U6VbuGV7Hu7ql59qYGxqla
   k=;
X-Amazon-filename: 0001-ext4-allow_multi_rsv_conversion_queue.patch
X-IronPort-AV: E=Sophos;i="5.96,149,1665446400"; 
   d="scan'208,223";a="264806384"
Subject: RE: significant drop  fio IOPS performance on v5.10
Thread-Topic: significant drop  fio IOPS performance on v5.10
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-b538c141.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 01:02:50 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-b538c141.us-east-1.amazon.com (Postfix) with ESMTPS id DDC2DA2E40;
        Wed,  9 Nov 2022 01:02:47 +0000 (UTC)
Received: from EX19D045UWC001.ant.amazon.com (10.13.139.223) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 9 Nov 2022 01:02:36 +0000
Received: from EX19D017UWC003.ant.amazon.com (10.13.139.227) by
 EX19D045UWC001.ant.amazon.com (10.13.139.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.15; Wed, 9 Nov 2022 01:02:35 +0000
Received: from EX19D017UWC003.ant.amazon.com ([fe80::78e9:1d67:81fd:68c5]) by
 EX19D017UWC003.ant.amazon.com ([fe80::78e9:1d67:81fd:68c5%6]) with mapi id
 15.02.1118.015; Wed, 9 Nov 2022 01:02:35 +0000
From:   "Lu, Davina" <davinalu@amazon.com>
To:     Theodore Ts'o <tytso@mit.edu>
CC:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>,
        hazem ahmed mohamed <hazem.ahmed.abuelfotoh@gmail.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        "Kiselev, Oleg" <okiselev@amazon.com>,
        "Liu, Frank" <franklmz@amazon.com>
Thread-Index: AdjO5vTzPItE0he4TsCHXHwBRGK6iAB1NzvQAJElJTAAIpWHgAfkS1gQ
Date:   Wed, 9 Nov 2022 01:02:35 +0000
Message-ID: <53153bdf0cce4675b09bc2ee6483409f@amazon.com>
References: <357ace228adf4e859df5e9f3f4f18b49@amazon.com>
 <1cdc68e6a98d4e93a95be5d887bcc75d@amazon.com>
 <5c819c9d6190452f9b10bb78a72cb47f@amazon.com> <YzTMZ26AfioIbl27@mit.edu>
In-Reply-To: <YzTMZ26AfioIbl27@mit.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.43.143.134]
Content-Type: multipart/mixed;
        boundary="_002_53153bdf0cce4675b09bc2ee6483409famazoncom_"
MIME-Version: 1.0
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--_002_53153bdf0cce4675b09bc2ee6483409famazoncom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Ted,

For adding the lock per inode per CPU, I didn't use the "inode->i_data_sem"=
 since this already been added to protect at ext4_map_blocks(). This will b=
een called eventually by ext4-rsv-conversion workqueue. So not sure if we s=
till need to another semaphore for per inode protection?

So I just simply add a new rw_semaphore under ext4_inode_info, also change =
the maximum queue size won't be more than supported CPU number. I tested fi=
o and xfstest-dev ext4 cases and all good here.

Not sure your opinions about the protection, the patch is below and I also =
put into attachment.

Thanks
Davina

From 4906bba1e9ce127fb8a92cf709c3948ac92c617c Mon Sep 17 00:00:00 2001
From: davinalu <davinalu@amazon.com>
Date: Wed, 9 Nov 2022 00:44:25 +0000
Subject: [PATCH] ext4:allow_multi_rsv_conversion_queue

---
 fs/ext4/ext4.h    | 1 +
 fs/ext4/extents.c | 4 +++-
 fs/ext4/super.c   | 5 ++++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3bf9a6926798..4414750b0134 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1166,6 +1166,7 @@ struct ext4_inode_info {
        atomic_t i_unwritten; /* Nr. of inflight conversions pending */

        spinlock_t i_block_reservation_lock;
+       struct rw_semaphore i_rsv_unwritten_sem;

        /*
         * Transactions that contain inode's metadata needed to complete
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5235974126bd..806393da92cf 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4808,8 +4808,9 @@ int ext4_convert_unwritten_extents(handle_t *handle, =
struct inode *inode,
                                break;
                        }
                }
+               down_write(&EXT4_I(inode)->i_rsv_unwritten_sem);
                ret =3D ext4_map_blocks(handle, inode, &map,
-                                     EXT4_GET_BLOCKS_IO_CONVERT_EXT);
+                               EXT4_GET_BLOCKS_IO_CONVERT_EXT);
                if (ret <=3D 0)
                        ext4_warning(inode->i_sb,
                                     "inode #%lu: block %u: len %u: "
@@ -4817,6 +4818,7 @@ int ext4_convert_unwritten_extents(handle_t *handle, =
struct inode *inode,
                                     inode->i_ino, map.m_lblk,
                                     map.m_len, ret);
                ret2 =3D ext4_mark_inode_dirty(handle, inode);
+               up_write(&EXT4_I(inode)->i_rsv_unwritten_sem);
                if (credits) {
                        ret3 =3D ext4_journal_stop(handle);
                        if (unlikely(ret3))
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 091db733834e..b3c7544798b8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1399,6 +1399,7 @@ static void init_once(void *foo)
        INIT_LIST_HEAD(&ei->i_orphan);
        init_rwsem(&ei->xattr_sem);
        init_rwsem(&ei->i_data_sem);
+       init_rwsem(&ei->i_rsv_unwritten_sem);
        inode_init_once(&ei->vfs_inode);
        ext4_fc_init_inode(&ei->vfs_inode);
 }
@@ -5212,7 +5213,9 @@ static int __ext4_fill_super(struct fs_context *fc, s=
truct super_block *sb)
         * concurrency isn't really necessary.  Limit it to 1.
         */
        EXT4_SB(sb)->rsv_conversion_wq =3D
-               alloc_workqueue("ext4-rsv-conversion", WQ_MEM_RECLAIM | WQ_=
UNBOUND, 1);
+               alloc_workqueue("ext4-rsv-conversion",
+                               WQ_MEM_RECLAIM | WQ_UNBOUND | __WQ_ORDERED,
+                               num_active_cpus() > 1 ? num_active_cpus() :=
 1);
        if (!EXT4_SB(sb)->rsv_conversion_wq) {
                printk(KERN_ERR "EXT4-fs: failed to create workqueue\n");
                ret =3D -ENOMEM;
--
2.37.1

-----Original Message-----
From: Theodore Ts'o <tytso@mit.edu>=20
Sent: Thursday, September 29, 2022 8:36 AM
To: Lu, Davina <davinalu@amazon.com>
Cc: linux-ext4@vger.kernel.org; adilger.kernel@dilger.ca; regressions@lists=
.linux.dev; stable@vger.kernel.org; Mohamed Abuelfotoh, Hazem <abuehaze@ama=
zon.com>; hazem ahmed mohamed <hazem.ahmed.abuelfotoh@gmail.com>; Ritesh Ha=
rjani (IBM) <ritesh.list@gmail.com>; Kiselev, Oleg <okiselev@amazon.com>; L=
iu, Frank <franklmz@amazon.com>
Subject: RE: [EXTERNAL]significant drop fio IOPS performance on v5.10

CAUTION: This email originated from outside of the organization. Do not cli=
ck links or open attachments unless you can confirm the sender and know the=
 content is safe.



On Wed, Sep 28, 2022 at 06:07:34AM +0000, Lu, Davina wrote:
>
> Hello,
>
> My analyzing is that the degradation is introduce by commit=20
> {244adf6426ee31a83f397b700d964cff12a247d3} and the issue is the=20
> contention on rsv_conversion_wq.  The simplest option is to increase=20
> the journal size, but that introduces more operational complexity.
> Another option is to add the following change in attachment "allow=20
> more ext4-rsv-conversion workqueue.patch"

Hi, thanks for the patch.  However, I don't believe as written it is safe. =
 That's because your patch will allow multiple CPU's to run ext4_flush_comp=
leted_IO(), and this function is not set up to be safe to be run concurrent=
ly.  That is, I don't see the necessary locking if we have two CPU's trying=
 to convert unwritten extents on the same inode.

It could be made safe, and certainly if the problem is that you are worried=
 about contention across multiple inodes being written to by different FIO =
jobs, then certainly this could be a potential contention issue.

However, what doesn't make sense is that increasing the journal size also s=
eems to fix the issue for you.  That implies the problem is one of the jour=
nal being to small, and so you are running into an issue of stalls caused b=
y the need to do a synchronous checkpoint to clear space in the journal.  T=
hat is a different problem than one of there being a contention problem wit=
h rsv_conversion_wq.

So I want to make sure we understand what you are seeing before we make suc=
h a change.  One potential concern is that will cause a large number of add=
itional kernel threads.  Now, if these extra kernel threads are doing usefu=
l work, then that's not necessarily an issue.
But if not, then it's going to be burning a large amount of kernel memory (=
especially for a system with a large number of CPU cores).

Regards,

                                        - Ted

--_002_53153bdf0cce4675b09bc2ee6483409famazoncom_
Content-Type: application/octet-stream;
	name="0001-ext4-allow_multi_rsv_conversion_queue.patch"
Content-Description: 0001-ext4-allow_multi_rsv_conversion_queue.patch
Content-Disposition: attachment;
	filename="0001-ext4-allow_multi_rsv_conversion_queue.patch"; size=2544;
	creation-date="Wed, 09 Nov 2022 01:01:49 GMT";
	modification-date="Wed, 09 Nov 2022 01:01:49 GMT"
Content-Transfer-Encoding: base64

RnJvbSA0OTA2YmJhMWU5Y2UxMjdmYjhhOTJjZjcwOWMzOTQ4YWM5MmM2MTdjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBkYXZpbmFsdSA8ZGF2aW5hbHVAYW1hem9uLmNvbT4KRGF0ZTog
V2VkLCA5IE5vdiAyMDIyIDAwOjQ0OjI1ICswMDAwClN1YmplY3Q6IFtQQVRDSF0gZXh0NDphbGxv
d19tdWx0aV9yc3ZfY29udmVyc2lvbl9xdWV1ZQoKLS0tCiBmcy9leHQ0L2V4dDQuaCAgICB8IDEg
KwogZnMvZXh0NC9leHRlbnRzLmMgfCA0ICsrKy0KIGZzL2V4dDQvc3VwZXIuYyAgIHwgNSArKysr
LQogMyBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZnMvZXh0NC9leHQ0LmggYi9mcy9leHQ0L2V4dDQuaAppbmRleCAzYmY5YTY5MjY3
OTguLjQ0MTQ3NTBiMDEzNCAxMDA2NDQKLS0tIGEvZnMvZXh0NC9leHQ0LmgKKysrIGIvZnMvZXh0
NC9leHQ0LmgKQEAgLTExNjYsNiArMTE2Niw3IEBAIHN0cnVjdCBleHQ0X2lub2RlX2luZm8gewog
CWF0b21pY190IGlfdW53cml0dGVuOyAvKiBOci4gb2YgaW5mbGlnaHQgY29udmVyc2lvbnMgcGVu
ZGluZyAqLwogCiAJc3BpbmxvY2tfdCBpX2Jsb2NrX3Jlc2VydmF0aW9uX2xvY2s7CisJc3RydWN0
IHJ3X3NlbWFwaG9yZSBpX3Jzdl91bndyaXR0ZW5fc2VtOwogCiAJLyoKIAkgKiBUcmFuc2FjdGlv
bnMgdGhhdCBjb250YWluIGlub2RlJ3MgbWV0YWRhdGEgbmVlZGVkIHRvIGNvbXBsZXRlCmRpZmYg
LS1naXQgYS9mcy9leHQ0L2V4dGVudHMuYyBiL2ZzL2V4dDQvZXh0ZW50cy5jCmluZGV4IDUyMzU5
NzQxMjZiZC4uODA2MzkzZGE5MmNmIDEwMDY0NAotLS0gYS9mcy9leHQ0L2V4dGVudHMuYworKysg
Yi9mcy9leHQ0L2V4dGVudHMuYwpAQCAtNDgwOCw4ICs0ODA4LDkgQEAgaW50IGV4dDRfY29udmVy
dF91bndyaXR0ZW5fZXh0ZW50cyhoYW5kbGVfdCAqaGFuZGxlLCBzdHJ1Y3QgaW5vZGUgKmlub2Rl
LAogCQkJCWJyZWFrOwogCQkJfQogCQl9CisJCWRvd25fd3JpdGUoJkVYVDRfSShpbm9kZSktPmlf
cnN2X3Vud3JpdHRlbl9zZW0pOwogCQlyZXQgPSBleHQ0X21hcF9ibG9ja3MoaGFuZGxlLCBpbm9k
ZSwgJm1hcCwKLQkJCQkgICAgICBFWFQ0X0dFVF9CTE9DS1NfSU9fQ09OVkVSVF9FWFQpOworCQkJ
CUVYVDRfR0VUX0JMT0NLU19JT19DT05WRVJUX0VYVCk7CiAJCWlmIChyZXQgPD0gMCkKIAkJCWV4
dDRfd2FybmluZyhpbm9kZS0+aV9zYiwKIAkJCQkgICAgICJpbm9kZSAjJWx1OiBibG9jayAldTog
bGVuICV1OiAiCkBAIC00ODE3LDYgKzQ4MTgsNyBAQCBpbnQgZXh0NF9jb252ZXJ0X3Vud3JpdHRl
bl9leHRlbnRzKGhhbmRsZV90ICpoYW5kbGUsIHN0cnVjdCBpbm9kZSAqaW5vZGUsCiAJCQkJICAg
ICBpbm9kZS0+aV9pbm8sIG1hcC5tX2xibGssCiAJCQkJICAgICBtYXAubV9sZW4sIHJldCk7CiAJ
CXJldDIgPSBleHQ0X21hcmtfaW5vZGVfZGlydHkoaGFuZGxlLCBpbm9kZSk7CisJCXVwX3dyaXRl
KCZFWFQ0X0koaW5vZGUpLT5pX3Jzdl91bndyaXR0ZW5fc2VtKTsKIAkJaWYgKGNyZWRpdHMpIHsK
IAkJCXJldDMgPSBleHQ0X2pvdXJuYWxfc3RvcChoYW5kbGUpOwogCQkJaWYgKHVubGlrZWx5KHJl
dDMpKQpkaWZmIC0tZ2l0IGEvZnMvZXh0NC9zdXBlci5jIGIvZnMvZXh0NC9zdXBlci5jCmluZGV4
IDA5MWRiNzMzODM0ZS4uYjNjNzU0NDc5OGI4IDEwMDY0NAotLS0gYS9mcy9leHQ0L3N1cGVyLmMK
KysrIGIvZnMvZXh0NC9zdXBlci5jCkBAIC0xMzk5LDYgKzEzOTksNyBAQCBzdGF0aWMgdm9pZCBp
bml0X29uY2Uodm9pZCAqZm9vKQogCUlOSVRfTElTVF9IRUFEKCZlaS0+aV9vcnBoYW4pOwogCWlu
aXRfcndzZW0oJmVpLT54YXR0cl9zZW0pOwogCWluaXRfcndzZW0oJmVpLT5pX2RhdGFfc2VtKTsK
Kwlpbml0X3J3c2VtKCZlaS0+aV9yc3ZfdW53cml0dGVuX3NlbSk7CiAJaW5vZGVfaW5pdF9vbmNl
KCZlaS0+dmZzX2lub2RlKTsKIAlleHQ0X2ZjX2luaXRfaW5vZGUoJmVpLT52ZnNfaW5vZGUpOwog
fQpAQCAtNTIxMiw3ICs1MjEzLDkgQEAgc3RhdGljIGludCBfX2V4dDRfZmlsbF9zdXBlcihzdHJ1
Y3QgZnNfY29udGV4dCAqZmMsIHN0cnVjdCBzdXBlcl9ibG9jayAqc2IpCiAJICogY29uY3VycmVu
Y3kgaXNuJ3QgcmVhbGx5IG5lY2Vzc2FyeS4gIExpbWl0IGl0IHRvIDEuCiAJICovCiAJRVhUNF9T
QihzYiktPnJzdl9jb252ZXJzaW9uX3dxID0KLQkJYWxsb2Nfd29ya3F1ZXVlKCJleHQ0LXJzdi1j
b252ZXJzaW9uIiwgV1FfTUVNX1JFQ0xBSU0gfCBXUV9VTkJPVU5ELCAxKTsKKwkJYWxsb2Nfd29y
a3F1ZXVlKCJleHQ0LXJzdi1jb252ZXJzaW9uIiwKKwkJCQlXUV9NRU1fUkVDTEFJTSB8IFdRX1VO
Qk9VTkQgfCBfX1dRX09SREVSRUQsCisJCQkJbnVtX2FjdGl2ZV9jcHVzKCkgPiAxID8gbnVtX2Fj
dGl2ZV9jcHVzKCkgOiAxKTsKIAlpZiAoIUVYVDRfU0Ioc2IpLT5yc3ZfY29udmVyc2lvbl93cSkg
ewogCQlwcmludGsoS0VSTl9FUlIgIkVYVDQtZnM6IGZhaWxlZCB0byBjcmVhdGUgd29ya3F1ZXVl
XG4iKTsKIAkJcmV0ID0gLUVOT01FTTsKLS0gCjIuMzcuMQoK

--_002_53153bdf0cce4675b09bc2ee6483409famazoncom_--
