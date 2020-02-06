Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13CAD153E98
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 07:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbgBFGQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 01:16:18 -0500
Received: from mga07.intel.com ([134.134.136.100]:50644 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgBFGQS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 01:16:18 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 22:16:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,408,1574150400"; 
   d="gz'50?scan'50,208,50";a="432117153"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 05 Feb 2020 22:16:14 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1izaSU-0002AH-5X; Thu, 06 Feb 2020 14:16:14 +0800
Date:   Thu, 6 Feb 2020 14:16:01 +0800
From:   kbuild test robot <lkp@intel.com>
To:     David Sterba <dsterba@suse.com>
Cc:     kbuild-all@lists.01.org, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: log message when rw remount is attempted with
 unclean tree-log
Message-ID: <202002061434.v6qo22Fp%lkp@intel.com>
References: <20200205161228.24378-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tz4fipvxmqik4g4b"
Content-Disposition: inline
In-Reply-To: <20200205161228.24378-1-dsterba@suse.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tz4fipvxmqik4g4b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi David,

I love your patch! Yet something to improve:

[auto build test ERROR on kdave/for-next]
[also build test ERROR on v5.5]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/David-Sterba/btrfs-log-message-when-rw-remount-is-attempted-with-unclean-tree-log/20200206-115926
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
config: h8300-randconfig-a001-20200206 (attached as .config)
compiler: h8300-linux-gcc (GCC) 7.5.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.5.0 make.cross ARCH=h8300 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from fs/btrfs/delayed-inode.h:17:0,
                    from fs/btrfs/super.c:30:
   fs/btrfs/super.c: In function 'btrfs_remount':
>> fs/btrfs/super.c:1837:15: error: 'f_info' undeclared (first use in this function); did you mean 'fs_info'?
       btrfs_warn(f_info,
                  ^
   fs/btrfs/ctree.h:3035:15: note: in definition of macro 'btrfs_warn'
     btrfs_printk(fs_info, KERN_WARNING fmt, ##args)
                  ^~~~~~~
   fs/btrfs/super.c:1837:15: note: each undeclared identifier is reported only once for each function it appears in
       btrfs_warn(f_info,
                  ^
   fs/btrfs/ctree.h:3035:15: note: in definition of macro 'btrfs_warn'
     btrfs_printk(fs_info, KERN_WARNING fmt, ##args)
                  ^~~~~~~

vim +1837 fs/btrfs/super.c

  1747	
  1748	static int btrfs_remount(struct super_block *sb, int *flags, char *data)
  1749	{
  1750		struct btrfs_fs_info *fs_info = btrfs_sb(sb);
  1751		struct btrfs_root *root = fs_info->tree_root;
  1752		unsigned old_flags = sb->s_flags;
  1753		unsigned long old_opts = fs_info->mount_opt;
  1754		unsigned long old_compress_type = fs_info->compress_type;
  1755		u64 old_max_inline = fs_info->max_inline;
  1756		u32 old_thread_pool_size = fs_info->thread_pool_size;
  1757		u32 old_metadata_ratio = fs_info->metadata_ratio;
  1758		int ret;
  1759	
  1760		sync_filesystem(sb);
  1761		btrfs_remount_prepare(fs_info);
  1762	
  1763		if (data) {
  1764			void *new_sec_opts = NULL;
  1765	
  1766			ret = security_sb_eat_lsm_opts(data, &new_sec_opts);
  1767			if (!ret)
  1768				ret = security_sb_remount(sb, new_sec_opts);
  1769			security_free_mnt_opts(&new_sec_opts);
  1770			if (ret)
  1771				goto restore;
  1772		}
  1773	
  1774		ret = btrfs_parse_options(fs_info, data, *flags);
  1775		if (ret)
  1776			goto restore;
  1777	
  1778		btrfs_remount_begin(fs_info, old_opts, *flags);
  1779		btrfs_resize_thread_pool(fs_info,
  1780			fs_info->thread_pool_size, old_thread_pool_size);
  1781	
  1782		if ((bool)(*flags & SB_RDONLY) == sb_rdonly(sb))
  1783			goto out;
  1784	
  1785		if (*flags & SB_RDONLY) {
  1786			/*
  1787			 * this also happens on 'umount -rf' or on shutdown, when
  1788			 * the filesystem is busy.
  1789			 */
  1790			cancel_work_sync(&fs_info->async_reclaim_work);
  1791	
  1792			btrfs_discard_cleanup(fs_info);
  1793	
  1794			/* wait for the uuid_scan task to finish */
  1795			down(&fs_info->uuid_tree_rescan_sem);
  1796			/* avoid complains from lockdep et al. */
  1797			up(&fs_info->uuid_tree_rescan_sem);
  1798	
  1799			sb->s_flags |= SB_RDONLY;
  1800	
  1801			/*
  1802			 * Setting SB_RDONLY will put the cleaner thread to
  1803			 * sleep at the next loop if it's already active.
  1804			 * If it's already asleep, we'll leave unused block
  1805			 * groups on disk until we're mounted read-write again
  1806			 * unless we clean them up here.
  1807			 */
  1808			btrfs_delete_unused_bgs(fs_info);
  1809	
  1810			btrfs_dev_replace_suspend_for_unmount(fs_info);
  1811			btrfs_scrub_cancel(fs_info);
  1812			btrfs_pause_balance(fs_info);
  1813	
  1814			ret = btrfs_commit_super(fs_info);
  1815			if (ret)
  1816				goto restore;
  1817		} else {
  1818			if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
  1819				btrfs_err(fs_info,
  1820					"Remounting read-write after error is not allowed");
  1821				ret = -EINVAL;
  1822				goto restore;
  1823			}
  1824			if (fs_info->fs_devices->rw_devices == 0) {
  1825				ret = -EACCES;
  1826				goto restore;
  1827			}
  1828	
  1829			if (!btrfs_check_rw_degradable(fs_info, NULL)) {
  1830				btrfs_warn(fs_info,
  1831			"too many missing devices, writable remount is not allowed");
  1832				ret = -EACCES;
  1833				goto restore;
  1834			}
  1835	
  1836			if (btrfs_super_log_root(fs_info->super_copy) != 0) {
> 1837				btrfs_warn(f_info,
  1838			"mount required to replay tree-log, cannot remount read-write");
  1839				ret = -EINVAL;
  1840				goto restore;
  1841			}
  1842	
  1843			ret = btrfs_cleanup_fs_roots(fs_info);
  1844			if (ret)
  1845				goto restore;
  1846	
  1847			/* recover relocation */
  1848			mutex_lock(&fs_info->cleaner_mutex);
  1849			ret = btrfs_recover_relocation(root);
  1850			mutex_unlock(&fs_info->cleaner_mutex);
  1851			if (ret)
  1852				goto restore;
  1853	
  1854			ret = btrfs_resume_balance_async(fs_info);
  1855			if (ret)
  1856				goto restore;
  1857	
  1858			ret = btrfs_resume_dev_replace_async(fs_info);
  1859			if (ret) {
  1860				btrfs_warn(fs_info, "failed to resume dev_replace");
  1861				goto restore;
  1862			}
  1863	
  1864			btrfs_qgroup_rescan_resume(fs_info);
  1865	
  1866			if (!fs_info->uuid_root) {
  1867				btrfs_info(fs_info, "creating UUID tree");
  1868				ret = btrfs_create_uuid_tree(fs_info);
  1869				if (ret) {
  1870					btrfs_warn(fs_info,
  1871						   "failed to create the UUID tree %d",
  1872						   ret);
  1873					goto restore;
  1874				}
  1875			}
  1876			sb->s_flags &= ~SB_RDONLY;
  1877	
  1878			set_bit(BTRFS_FS_OPEN, &fs_info->flags);
  1879		}
  1880	out:
  1881		wake_up_process(fs_info->transaction_kthread);
  1882		btrfs_remount_cleanup(fs_info, old_opts);
  1883		return 0;
  1884	
  1885	restore:
  1886		/* We've hit an error - don't reset SB_RDONLY */
  1887		if (sb_rdonly(sb))
  1888			old_flags |= SB_RDONLY;
  1889		sb->s_flags = old_flags;
  1890		fs_info->mount_opt = old_opts;
  1891		fs_info->compress_type = old_compress_type;
  1892		fs_info->max_inline = old_max_inline;
  1893		btrfs_resize_thread_pool(fs_info,
  1894			old_thread_pool_size, fs_info->thread_pool_size);
  1895		fs_info->metadata_ratio = old_metadata_ratio;
  1896		btrfs_remount_cleanup(fs_info, old_opts);
  1897		return ret;
  1898	}
  1899	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--tz4fipvxmqik4g4b
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--tz4fipvxmqik4g4b--
