Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E0036DCE
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 09:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfFFHwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 03:52:47 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:3032 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFFHwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 03:52:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1559807567; x=1591343567;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BefToM/pLl40Y4E81x4XEyviHbBACIRWepWjdmx7htg=;
  b=Jnj24akw+okb7skxWWSW0kFGrg8OuJFvP+xbNPg0iUtghxwmwPrg/WEQ
   jrqqJ9fnqiERXwPx6YYOe1c0YSG9L5nHY+yzaZ9QlNoGr9OzeoZoeJm/I
   a35fue6h6Zlp+j4/nSzoeZ+0ycLO4AeZWo551cM+nIzLfXdXkeD2JI3tt
   YpSjpi9IBOEBJpvpEULdeLQVDS1Qeg7oBtAaVowoMPMMQSizWcqze3MNs
   6myUJ+WZ2K2h7J8XDfg7R5Lg+NjZHEpHIdt8j1vWKtNIJaZc434jJ6yxD
   Jvu13sLHanxNO54HSgzN9rfonnXD56HGOZSFehMeweeqwn7ukvqMhJ0zz
   Q==;
X-IronPort-AV: E=Sophos;i="5.63,558,1557158400"; 
   d="scan'208";a="114878760"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jun 2019 15:52:46 +0800
IronPort-SDR: BJuQeviN+5g3jWB9hjWemkb8X3Yy15+dwR2RrguRE66Y6BM/4mSOzjnxNrDhFxUFPLpCFTYqiB
 fB1ImCJC9Frf+WTSJCBIom/ADfMhMi7u1URLwHIEW03hOCiUr94TwIAp4rap+DO4iJ7iPsVDTS
 iMyOFTnkou9LUqLM21eU3mmpEQVzRKKz8Yr22hI5HB6u20l9fSwObXMZH1yNjLzlrjVkrOO5E5
 Umhu8XPkQ1RkP1WL02NGTfeB2mnMPiwOpPNIxZKG3Eeb8gqms5IuxCxEYXAXZ4F1cb4me3IJLA
 7Xzf6r2gQtQsm4iOwyt+PF6z
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 06 Jun 2019 00:27:41 -0700
IronPort-SDR: VPDVEYnF/2nZuWktkUESLdYvA/cA8/clL8xnbI93qF8EKU0tA5U8Ywjd1J8lXDVdWPT7E5InOs
 TTYO3R9f0n9uOzltpxwNmjF1hLmDPC3Jt7J3qhTIAS3Qd10+HKsVw0ov1P/nCtyx6/Vm0Nl+KP
 lbAoIgK6W/ACmtgneBFL6OyT53YqFBQh3V0X51pQFJgwW7UHwfMAMBHpWvVTR9OQaZ5tr6RTxE
 wEcy3gbZ0p3nqz4tdAj7kCAbGPLUP9I6qkcOnFyC0jHiHA74j8S7JQSLm8+LnAFL3UOvbIv9WZ
 1DU=
Received: from naota.dhcp.fujisawa.hgst.com (HELO naota.fujisawa.hgst.com) ([10.149.53.115])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jun 2019 00:52:46 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: fix out-of-bounds access in property handling
Date:   Thu,  6 Jun 2019 16:49:25 +0900
Message-Id: <20190606074925.12375-1-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

xattr value is not NULL-terminated string. When you specify "lz" as the
property value, strncmp("lzo", value, 3) will try to read one byte after
the value buffer, causing the following OOB access. Fix this out-of-bound
by explicitly check the required length.

[ 1519.998589] ==================================================================
[ 1520.007505] BUG: KASAN: slab-out-of-bounds in strncmp+0xab/0xc0
[ 1520.015116] Read of size 1 at addr ffff8886daec16c2 by task btrfs/15317

[ 1520.026628] CPU: 4 PID: 15317 Comm: btrfs Not tainted 5.1.0-rc7+ #3
[ 1520.034635] Hardware name: Supermicro X10SLL-F/X10SLL-F, BIOS 3.0 04/24/2015
[ 1520.043416] Call Trace:
[ 1520.047562]  dump_stack+0x71/0xa0
[ 1520.052584]  print_address_description+0x65/0x229
[ 1520.058997]  ? strncmp+0xab/0xc0
[ 1520.063929]  ? strncmp+0xab/0xc0
[ 1520.068834]  kasan_report.cold+0x1a/0x38
[ 1520.074439]  ? strncmp+0xab/0xc0
[ 1520.079343]  strncmp+0xab/0xc0
[ 1520.084110]  prop_compression_validate+0x22/0x70 [btrfs]
[ 1520.091135]  btrfs_xattr_handler_set_prop+0x6c/0x1f0 [btrfs]
[ 1520.098452]  __vfs_setxattr+0xd8/0x130
[ 1520.103821]  ? xattr_resolve_name+0x3e0/0x3e0
[ 1520.109812]  __vfs_setxattr_noperm+0xeb/0x3b0
[ 1520.115790]  vfs_setxattr+0xa3/0xd0
[ 1520.120898]  setxattr+0x17a/0x2c0
[ 1520.125824]  ? vfs_setxattr+0xd0/0xd0
[ 1520.131102]  ? __pmd_alloc+0x560/0x560
[ 1520.136452]  ? __do_sys_newfstat+0xd3/0xe0
[ 1520.142123]  ? __ia32_sys_newfstatat+0xf0/0xf0
[ 1520.148140]  ? __kasan_slab_free+0x141/0x170
[ 1520.153955]  ? handle_mm_fault+0x1ae/0x640
[ 1520.159564]  __x64_sys_fsetxattr+0x1a0/0x220
[ 1520.165347]  do_syscall_64+0xa0/0x2e0
[ 1520.170515]  ? page_fault+0x8/0x30
[ 1520.175408]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1520.181975] RIP: 0033:0x7f84f257ae6e
[ 1520.187068] Code: 48 8b 0d 1d 70 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 be 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ea 6f 0c 00 f7 d8 64 89 01 48
[ 1520.209083] RSP: 002b:00007fff87996fa8 EFLAGS: 00000246 ORIG_RAX: 00000000000000be
[ 1520.218336] RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f84f257ae6e
[ 1520.227132] RDX: 00007fff8799798b RSI: 00005561caf83270 RDI: 0000000000000003
[ 1520.235912] RBP: 00007fff8799798b R08: 0000000000000000 R09: 00005561caf83290
[ 1520.244691] R10: 0000000000000002 R11: 0000000000000246 R12: 00005561caf83270
[ 1520.253462] R13: 0000000000000003 R14: 00007fff87997972 R15: 00007fff8799797f

[ 1520.265443] Allocated by task 15317:
[ 1520.270697]  __kasan_kmalloc.constprop.0+0xc2/0xd0
[ 1520.277677]  setxattr+0xe8/0x2c0
[ 1520.283084]  __x64_sys_fsetxattr+0x1a0/0x220
[ 1520.289540]  do_syscall_64+0xa0/0x2e0
[ 1520.295379]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

[ 1520.306288] Freed by task 12227:
[ 1520.311632]  __kasan_slab_free+0x12c/0x170
[ 1520.317828]  kfree+0x90/0x1e0
[ 1520.322891]  btrfs_free_block_groups+0x8a1/0xd80 [btrfs]
[ 1520.330313]  close_ctree+0x37e/0x650 [btrfs]
[ 1520.336627]  generic_shutdown_super+0x12e/0x320
[ 1520.343177]  kill_anon_super+0x36/0x60
[ 1520.348983]  btrfs_kill_super+0x3d/0x2c0 [btrfs]
[ 1520.355636]  deactivate_locked_super+0x85/0xd0
[ 1520.362108]  deactivate_super+0x122/0x140
[ 1520.368166]  cleanup_mnt+0x9f/0x130
[ 1520.373699]  task_work_run+0x131/0x1c0
[ 1520.379490]  exit_to_usermode_loop+0x133/0x160
[ 1520.386002]  do_syscall_64+0x259/0x2e0
[ 1520.391796]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

[ 1520.402415] The buggy address belongs to the object at ffff8886daec16c0
                which belongs to the cache kmalloc-8 of size 8
[ 1520.418769] The buggy address is located 2 bytes inside of
                8-byte region [ffff8886daec16c0, ffff8886daec16c8)
[ 1520.434407] The buggy address belongs to the page:
[ 1520.441358] page:ffffea001b6bb040 count:1 mapcount:0 mapping:ffff8886ff40fb80 index:0x0
[ 1520.451601] flags: 0x17ffe000000200(slab)
[ 1520.457868] raw: 0017ffe000000200 ffffea001bedcec0 0000000700000007 ffff8886ff40fb80
[ 1520.467940] raw: 0000000000000000 0000000080aa00aa 00000001ffffffff 0000000000000000
[ 1520.478024] page dumped because: kasan: bad access detected

[ 1520.489795] Memory state around the buggy address:
[ 1520.496963]  ffff8886daec1580: fc 00 fc fc 00 fc fc 00 fc fc 00 fc fc 00 fc fc
[ 1520.506621]  ffff8886daec1600: 00 fc fc 04 fc fc fb fc fc fb fc fc fb fc fc fb
[ 1520.516277] >ffff8886daec1680: fc fc 04 fc fc 00 fc fc 02 fc fc fb fc fc 00 fc
[ 1520.525915]                                            ^
[ 1520.533584]  ffff8886daec1700: fc 00 fc fc 00 fc fc 00 fc fc 00 fc fc 04 fc fc
[ 1520.543137]  ffff8886daec1780: fb fc fc 00 fc fc 00 fc fc 00 fc fc 00 fc fc 00
[ 1520.552642] ==================================================================

Fixes: 272e5326c783 ("btrfs: prop: fix vanished compression property after failed set")
Fixes: 50398fde997f ("btrfs: prop: fix zstd compression parameter validation")
Cc: stable@vger.kernel.org # 4.14+: 802a5c69584a: btrfs: prop: use common helper for type to string conversion
Cc: stable@vger.kernel.org # 4.14+: 3dcf96c7b9fe: btrfs: drop redundant forward declaration in props.c
Cc: stable@vger.kernel.org # 4.14+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 fs/btrfs/props.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index a9e2e66152ee..428141bf545d 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -257,11 +257,11 @@ static int prop_compression_validate(const char *value, size_t len)
 	if (!value)
 		return 0;
 
-	if (!strncmp("lzo", value, 3))
+	if (len >= 3 && !strncmp("lzo", value, 3))
 		return 0;
-	else if (!strncmp("zlib", value, 4))
+	else if (len >= 4 && !strncmp("zlib", value, 4))
 		return 0;
-	else if (!strncmp("zstd", value, 4))
+	else if (len >= 4 && !strncmp("zstd", value, 4))
 		return 0;
 
 	return -EINVAL;
@@ -281,12 +281,12 @@ static int prop_compression_apply(struct inode *inode, const char *value,
 		return 0;
 	}
 
-	if (!strncmp("lzo", value, 3)) {
+	if (len >= 3 && !strncmp("lzo", value, 3)) {
 		type = BTRFS_COMPRESS_LZO;
 		btrfs_set_fs_incompat(fs_info, COMPRESS_LZO);
-	} else if (!strncmp("zlib", value, 4)) {
+	} else if (len >= 4 && !strncmp("zlib", value, 4)) {
 		type = BTRFS_COMPRESS_ZLIB;
-	} else if (!strncmp("zstd", value, 4)) {
+	} else if (len >= 4 && !strncmp("zstd", value, 4)) {
 		type = BTRFS_COMPRESS_ZSTD;
 		btrfs_set_fs_incompat(fs_info, COMPRESS_ZSTD);
 	} else {
-- 
2.21.0

