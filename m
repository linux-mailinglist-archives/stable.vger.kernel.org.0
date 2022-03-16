Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E1D4DA74D
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 02:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344899AbiCPBXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 21:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239951AbiCPBXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 21:23:46 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D165D5D3;
        Tue, 15 Mar 2022 18:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647393753; x=1678929753;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sOmWI/JX2zd3KAThJoRSzxkUIfqthqS4raz/5dVW1Ms=;
  b=R+KxFMmfzNINZCxfR5cvBzub471VuSCmkNyYcAgkrnK+OcgtOWWiDRHO
   9BTTYfqYHklrjr4gjUBMUNjLx8ODxbR08YSiZAUw/osvaAq12idY0O85z
   8DOKrC4Ec2lHRJFTOGco0TnPDeLNCvS5KVNivM6amfavvnms/2e2DbsoL
   Q7Iq+dn2hnsaUEnWfelkgFJdYyJ4P0lFxMulk3FDur+Xl6fsFo5SSSDxg
   UnGCZY3KccslKuwKV0ZlLOu6EMLW02C6MPBzn8KL0jTd7+4+o7vSPeAPH
   3qXTSAqz5imv6qrKpFajGndvgyz7Wbc5dbddQk23AlToB8pOyQp0/01Bq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="254019666"
X-IronPort-AV: E=Sophos;i="5.90,185,1643702400"; 
   d="scan'208";a="254019666"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 18:22:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,185,1643702400"; 
   d="scan'208";a="598523517"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 15 Mar 2022 18:22:30 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nUIMv-000BkZ-Sn; Wed, 16 Mar 2022 01:22:29 +0000
Date:   Wed, 16 Mar 2022 09:22:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Theodore Ts'o <tytso@mit.edu>
Cc:     kbuild-all@lists.01.org, Tadeusz Struk <tadeusz.struk@linaro.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+7a806094edd5d07ba029@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: check if offset+length is within a valid range in
 fallocate
Message-ID: <202203160919.MtfBk5N0-lkp@intel.com>
References: <20220315191545.187366-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315191545.187366-1-tadeusz.struk@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tadeusz,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on tytso-ext4/dev]
[also build test ERROR on linus/master v5.17-rc8 next-20220315]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Tadeusz-Struk/ext4-check-if-offset-length-is-within-a-valid-range-in-fallocate/20220316-031841
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
config: arc-randconfig-r043-20220313 (https://download.01.org/0day-ci/archive/20220316/202203160919.MtfBk5N0-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/bc1fdc20f07523e970c9dea4f0fbabbc437fb0d5
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Tadeusz-Struk/ext4-check-if-offset-length-is-within-a-valid-range-in-fallocate/20220316-031841
        git checkout bc1fdc20f07523e970c9dea4f0fbabbc437fb0d5
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash fs/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   fs/ext4/inode.c: In function 'ext4_punch_hole':
>> fs/ext4/inode.c:4002:50: error: 'struct ext4_sb_info' has no member named 's_blocksize'
    4002 |         max_length = sbi->s_bitmap_maxbytes - sbi->s_blocksize;
         |                                                  ^~


vim +4002 fs/ext4/inode.c

  3937	
  3938	/*
  3939	 * ext4_punch_hole: punches a hole in a file by releasing the blocks
  3940	 * associated with the given offset and length
  3941	 *
  3942	 * @inode:  File inode
  3943	 * @offset: The offset where the hole will begin
  3944	 * @len:    The length of the hole
  3945	 *
  3946	 * Returns: 0 on success or negative on failure
  3947	 */
  3948	
  3949	int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
  3950	{
  3951		struct super_block *sb = inode->i_sb;
  3952		ext4_lblk_t first_block, stop_block;
  3953		struct address_space *mapping = inode->i_mapping;
  3954		loff_t first_block_offset, last_block_offset, max_length;
  3955		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
  3956		handle_t *handle;
  3957		unsigned int credits;
  3958		int ret = 0, ret2 = 0;
  3959	
  3960		trace_ext4_punch_hole(inode, offset, length, 0);
  3961	
  3962		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
  3963		if (ext4_has_inline_data(inode)) {
  3964			filemap_invalidate_lock(mapping);
  3965			ret = ext4_convert_inline_data(inode);
  3966			filemap_invalidate_unlock(mapping);
  3967			if (ret)
  3968				return ret;
  3969		}
  3970	
  3971		/*
  3972		 * Write out all dirty pages to avoid race conditions
  3973		 * Then release them.
  3974		 */
  3975		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
  3976			ret = filemap_write_and_wait_range(mapping, offset,
  3977							   offset + length - 1);
  3978			if (ret)
  3979				return ret;
  3980		}
  3981	
  3982		inode_lock(inode);
  3983	
  3984		/* No need to punch hole beyond i_size */
  3985		if (offset >= inode->i_size)
  3986			goto out_mutex;
  3987	
  3988		/*
  3989		 * If the hole extends beyond i_size, set the hole
  3990		 * to end after the page that contains i_size
  3991		 */
  3992		if (offset + length > inode->i_size) {
  3993			length = inode->i_size +
  3994			   PAGE_SIZE - (inode->i_size & (PAGE_SIZE - 1)) -
  3995			   offset;
  3996		}
  3997	
  3998		/*
  3999		 * For punch hole the length + offset needs to be at least within
  4000		 * one block before last
  4001		 */
> 4002		max_length = sbi->s_bitmap_maxbytes - sbi->s_blocksize;
  4003		if (offset + length >= max_length) {
  4004			ret = -ENOSPC;
  4005			goto out_mutex;
  4006		}
  4007	
  4008		if (offset & (sb->s_blocksize - 1) ||
  4009		    (offset + length) & (sb->s_blocksize - 1)) {
  4010			/*
  4011			 * Attach jinode to inode for jbd2 if we do any zeroing of
  4012			 * partial block
  4013			 */
  4014			ret = ext4_inode_attach_jinode(inode);
  4015			if (ret < 0)
  4016				goto out_mutex;
  4017	
  4018		}
  4019	
  4020		/* Wait all existing dio workers, newcomers will block on i_rwsem */
  4021		inode_dio_wait(inode);
  4022	
  4023		/*
  4024		 * Prevent page faults from reinstantiating pages we have released from
  4025		 * page cache.
  4026		 */
  4027		filemap_invalidate_lock(mapping);
  4028	
  4029		ret = ext4_break_layouts(inode);
  4030		if (ret)
  4031			goto out_dio;
  4032	
  4033		first_block_offset = round_up(offset, sb->s_blocksize);
  4034		last_block_offset = round_down((offset + length), sb->s_blocksize) - 1;
  4035	
  4036		/* Now release the pages and zero block aligned part of pages*/
  4037		if (last_block_offset > first_block_offset) {
  4038			ret = ext4_update_disksize_before_punch(inode, offset, length);
  4039			if (ret)
  4040				goto out_dio;
  4041			truncate_pagecache_range(inode, first_block_offset,
  4042						 last_block_offset);
  4043		}
  4044	
  4045		if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
  4046			credits = ext4_writepage_trans_blocks(inode);
  4047		else
  4048			credits = ext4_blocks_for_truncate(inode);
  4049		handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
  4050		if (IS_ERR(handle)) {
  4051			ret = PTR_ERR(handle);
  4052			ext4_std_error(sb, ret);
  4053			goto out_dio;
  4054		}
  4055	
  4056		ret = ext4_zero_partial_blocks(handle, inode, offset,
  4057					       length);
  4058		if (ret)
  4059			goto out_stop;
  4060	
  4061		first_block = (offset + sb->s_blocksize - 1) >>
  4062			EXT4_BLOCK_SIZE_BITS(sb);
  4063		stop_block = (offset + length) >> EXT4_BLOCK_SIZE_BITS(sb);
  4064	
  4065		/* If there are blocks to remove, do it */
  4066		if (stop_block > first_block) {
  4067	
  4068			down_write(&EXT4_I(inode)->i_data_sem);
  4069			ext4_discard_preallocations(inode, 0);
  4070	
  4071			ret = ext4_es_remove_extent(inode, first_block,
  4072						    stop_block - first_block);
  4073			if (ret) {
  4074				up_write(&EXT4_I(inode)->i_data_sem);
  4075				goto out_stop;
  4076			}
  4077	
  4078			if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
  4079				ret = ext4_ext_remove_space(inode, first_block,
  4080							    stop_block - 1);
  4081			else
  4082				ret = ext4_ind_remove_space(handle, inode, first_block,
  4083							    stop_block);
  4084	
  4085			up_write(&EXT4_I(inode)->i_data_sem);
  4086		}
  4087		ext4_fc_track_range(handle, inode, first_block, stop_block);
  4088		if (IS_SYNC(inode))
  4089			ext4_handle_sync(handle);
  4090	
  4091		inode->i_mtime = inode->i_ctime = current_time(inode);
  4092		ret2 = ext4_mark_inode_dirty(handle, inode);
  4093		if (unlikely(ret2))
  4094			ret = ret2;
  4095		if (ret >= 0)
  4096			ext4_update_inode_fsync_trans(handle, inode, 1);
  4097	out_stop:
  4098		ext4_journal_stop(handle);
  4099	out_dio:
  4100		filemap_invalidate_unlock(mapping);
  4101	out_mutex:
  4102		inode_unlock(inode);
  4103		return ret;
  4104	}
  4105	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
