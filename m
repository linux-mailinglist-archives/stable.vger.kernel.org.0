Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4BAE59D067
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 07:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239928AbiHWFWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 01:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239904AbiHWFWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 01:22:35 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A6451A2C;
        Mon, 22 Aug 2022 22:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661232154; x=1692768154;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wy6WE4BSFS1ZfWH9ztxUHavzMVRtvmcIr8EplprCa+8=;
  b=emZz3Cmo4G1mjQFdjJxfvVxAFlkyUB2Gh5ARZILw/N26uyiXiuiKvAJv
   yMyMkRihkQWkNJu33MtD0BszngoXPluD5cAjvtjJ3a3H3MGDA47Ro00sO
   +4hL/2nrBSnX2y7VSfkgiOAnp+YruoG8CaN/Ok7n3d81fAmmynHuPTbUu
   KdMQWr9x0EdEULuW6PTrUzFi/Wev6r0Hh+UD34xO3Ple6VKs6UvT83ub9
   DkVbYS9Paj7NDBUHkigdrSgAcySc+sIL4PJOTNs9IYMtVfs5oVeYvf5AJ
   yzb4nGDVX2W4/t8RYTny6hMvrvGtLqWEPQ4zAgXmUtPs4vA+DBHiR8ixh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="294383553"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="294383553"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 22:22:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="642307329"
Received: from lkp-server01.sh.intel.com (HELO dd9b29378baa) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 22 Aug 2022 22:22:31 -0700
Received: from kbuild by dd9b29378baa with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oQMMx-0001DV-02;
        Tue, 23 Aug 2022 05:22:31 +0000
Date:   Tue, 23 Aug 2022 13:22:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     Michael Schmitz <schmitzmic@gmail.com>,
        linux-block@vger.kernel.org, axboe@kernel.dk
Cc:     kbuild-all@lists.01.org, linux-m68k@vger.kernel.org,
        geert@linux-m68k.org, hch@lst.de,
        Michael Schmitz <schmitzmic@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v9 RESEND #2 2/2] block: add overflow checks for Amiga
 partition support
Message-ID: <202208231319.Ng5RTzzg-lkp@intel.com>
References: <20220822211236.9023-3-schmitzmic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822211236.9023-3-schmitzmic@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Michael,

I love your patch! Perhaps something to improve:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master v6.0-rc2 next-20220822]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Michael-Schmitz/Amiga-RDB-partition-support-fixes/20220823-051457
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: i386-randconfig-s002 (https://download.01.org/0day-ci/archive/20220823/202208231319.Ng5RTzzg-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/6b86551e8891f07839a8c3ad19e3f770b0f738e9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Michael-Schmitz/Amiga-RDB-partition-support-fixes/20220823-051457
        git checkout 6b86551e8891f07839a8c3ad19e3f770b0f738e9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash block/partitions/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> block/partitions/amiga.c:132:30: sparse: sparse: cast to restricted __be32
   block/partitions/amiga.c:133:25: sparse: sparse: cast to restricted __be32

vim +132 block/partitions/amiga.c

    35	
    36	int amiga_partition(struct parsed_partitions *state)
    37	{
    38		Sector sect;
    39		unsigned char *data;
    40		struct RigidDiskBlock *rdb;
    41		struct PartitionBlock *pb;
    42		u64 start_sect, nr_sects;
    43		sector_t blk, end_sect;
    44		u32 cylblk;		/* rdb_CylBlocks = nr_heads*sect_per_track */
    45		u32 nr_hd, nr_sect, lo_cyl, hi_cyl;
    46		int part, res = 0;
    47		unsigned int blksize = 1;	/* Multiplier for disk block size */
    48		int slot = 1;
    49	
    50		for (blk = 0; ; blk++, put_dev_sector(sect)) {
    51			if (blk == RDB_ALLOCATION_LIMIT)
    52				goto rdb_done;
    53			data = read_part_sector(state, blk, &sect);
    54			if (!data) {
    55				pr_err("Dev %s: unable to read RDB block %llu\n",
    56				       state->disk->disk_name, blk);
    57				res = -1;
    58				goto rdb_done;
    59			}
    60			if (*(__be32 *)data != cpu_to_be32(IDNAME_RIGIDDISK))
    61				continue;
    62	
    63			rdb = (struct RigidDiskBlock *)data;
    64			if (checksum_block((__be32 *)data, be32_to_cpu(rdb->rdb_SummedLongs) & 0x7F) == 0)
    65				break;
    66			/* Try again with 0xdc..0xdf zeroed, Windows might have
    67			 * trashed it.
    68			 */
    69			*(__be32 *)(data+0xdc) = 0;
    70			if (checksum_block((__be32 *)data,
    71					be32_to_cpu(rdb->rdb_SummedLongs) & 0x7F)==0) {
    72				pr_err("Trashed word at 0xd0 in block %llu ignored in checksum calculation\n",
    73				       blk);
    74				break;
    75			}
    76	
    77			pr_err("Dev %s: RDB in block %llu has bad checksum\n",
    78			       state->disk->disk_name, blk);
    79		}
    80	
    81		/* blksize is blocks per 512 byte standard block */
    82		blksize = be32_to_cpu( rdb->rdb_BlockBytes ) / 512;
    83	
    84		{
    85			char tmp[7 + 10 + 1 + 1];
    86	
    87			/* Be more informative */
    88			snprintf(tmp, sizeof(tmp), " RDSK (%d)", blksize * 512);
    89			strlcat(state->pp_buf, tmp, PAGE_SIZE);
    90		}
    91		blk = be32_to_cpu(rdb->rdb_PartitionList);
    92		put_dev_sector(sect);
    93		for (part = 1; blk>0 && part<=16; part++, put_dev_sector(sect)) {
    94			/* Read in terms partition table understands */
    95			if (check_mul_overflow(blk, (sector_t) blksize, &blk)) {
    96				pr_err("Dev %s: overflow calculating partition block %llu! Skipping partitions %u and beyond\n",
    97					state->disk->disk_name, blk, part);
    98				break;
    99			}
   100			data = read_part_sector(state, blk, &sect);
   101			if (!data) {
   102				pr_err("Dev %s: unable to read partition block %llu\n",
   103				       state->disk->disk_name, blk);
   104				res = -1;
   105				goto rdb_done;
   106			}
   107			pb  = (struct PartitionBlock *)data;
   108			blk = be32_to_cpu(pb->pb_Next);
   109			if (pb->pb_ID != cpu_to_be32(IDNAME_PARTITION))
   110				continue;
   111			if (checksum_block((__be32 *)pb, be32_to_cpu(pb->pb_SummedLongs) & 0x7F) != 0 )
   112				continue;
   113	
   114			/* RDB gives us more than enough rope to hang ourselves with,
   115			 * many times over (2^128 bytes if all fields max out).
   116			 * Some careful checks are in order, so check for potential
   117			 * overflows.
   118			 * We are multiplying four 32 bit numbers to one sector_t!
   119			 */
   120	
   121			nr_hd   = be32_to_cpu(pb->pb_Environment[NR_HD]);
   122			nr_sect = be32_to_cpu(pb->pb_Environment[NR_SECT]);
   123	
   124			/* CylBlocks is total number of blocks per cylinder */
   125			if (check_mul_overflow(nr_hd, nr_sect, &cylblk)) {
   126				pr_err("Dev %s: heads*sects %u overflows u32, skipping partition!\n",
   127					state->disk->disk_name, cylblk);
   128				continue;
   129			}
   130	
   131			/* check for consistency with RDB defined CylBlocks */
 > 132			if (cylblk > be32_to_cpu((__be32)rdb->rdb_CylBlocks)) {

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
