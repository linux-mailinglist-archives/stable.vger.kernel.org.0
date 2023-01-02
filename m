Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C9165B0F1
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjABL3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbjABL3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:29:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6766545;
        Mon,  2 Jan 2023 03:28:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0D5860F59;
        Mon,  2 Jan 2023 11:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAAFC433D2;
        Mon,  2 Jan 2023 11:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658896;
        bh=diQ4GLTq9QEbwfOfC9Xd6GNCUQsJbERyRzIRC2+Osdg=;
        h=From:To:Cc:Subject:Date:From;
        b=rEzCiAx2ZBY9UkpxApmxqom3DVNOxci47w7dA6+T7wArhardEs1HB876PxZm5mgux
         eRY2nSR/OzHB18JC0lvCyzn4FJlpCwMYahepaRdDsv+M9iY4dwgNQtdY3AvQYv695e
         tjHbXiQmKomy6O0BvyA/eQ6bKBFuBdH9AsbW9vu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.0 00/74] 6.0.17-rc1 review
Date:   Mon,  2 Jan 2023 12:21:33 +0100
Message-Id: <20230102110552.061937047@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.17-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.0.17-rc1
X-KernelTest-Deadline: 2023-01-04T11:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.0.17 release.
There are 74 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.17-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.0.17-rc1

Marco Elver <elver@google.com>
    kcsan: Instrument memcpy/memset/memmove with newer Clang

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Don't leak netobj memory when gss_read_proxy_verf() fails

Hanjun Guo <guohanjun@huawei.com>
    tpm: tpm_tis: Add the missed acpi_put_table() to fix memory leak

Hanjun Guo <guohanjun@huawei.com>
    tpm: tpm_crb: Add the missed acpi_put_table() to fix memory leak

Hanjun Guo <guohanjun@huawei.com>
    tpm: acpi: Call acpi_put_table() to fix memory leak

Deren Wu <deren.wu@mediatek.com>
    mmc: vub300: fix warning - do not call blocking ops when !TASK_RUNNING

Jan Kara <jack@suse.cz>
    block: Do not reread partition table on exclusively open device

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: allow to read node block after shutdown

Pavel Machek <pavel@denx.de>
    f2fs: should put a page when checking the summary info

NARIBAYASHI Akira <a.naribayashi@fujitsu.com>
    mm, compaction: fix fast_isolate_around() to stay within boundaries

Mikulas Patocka <mpatocka@redhat.com>
    md: fix a crash in mempool_free

ChiYuan Huang <cy_huang@richtek.com>
    mfd: mt6360: Add bounds checking in Regmap read/write call-backs

Christian Brauner <brauner@kernel.org>
    pnode: terminate at peers of source

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi: Static PCM mapping again with AMD HDMI codecs

Artem Egorkine <arteme@gmail.com>
    ALSA: line6: fix stack overflow in line6_midi_transmit

Artem Egorkine <arteme@gmail.com>
    ALSA: line6: correct midi status byte when receiving data from podxt

Al Viro <viro@zeniv.linux.org.uk>
    ovl: update ->f_iocb_flags when ovl_change_flags() modifies ->f_flags

Zhang Tianci <zhangtianci.1997@bytedance.com>
    ovl: Use ovl mounter's fsuid and fsgid in ovl_link()

Wang Yufen <wangyufen@huawei.com>
    binfmt: Fix error return code in load_elf_fdpic_binary()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: dont remove file from msg_ring reqs

Jens Axboe <axboe@kernel.dk>
    eventfd: provide a eventfd_signal_mask() helper

Jens Axboe <axboe@kernel.dk>
    eventpoll: add EPOLL_URING_WAKE poll wakeup flag

Aditya Garg <gargaditya08@live.com>
    hfsplus: fix bug causing custom uid and gid being unable to be assigned with mount

Qiujun Huang <hqjagain@gmail.com>
    pstore/zone: Use GFP_ATOMIC to allocate zone buffer

Luca Stefani <luca@osomprivacy.com>
    pstore: Properly assign mem_type property

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    mm/mempolicy: fix memory leak in set_mempolicy_home_node system call

Mel Gorman <mgorman@techsingularity.net>
    rtmutex: Add acquire semantics for rtmutex lock acquisition slow path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    futex: Fix futex_waitv() hrtimer debug object leak on kcalloc error

Terry Junge <linuxhid@cosmicgizmosystems.com>
    HID: plantronics: Additional PIDs for double volume key presses quirk

José Expósito <jose.exposito89@gmail.com>
    HID: multitouch: fix Asus ExpertBook P2 P2451FA trackpoint

wuqiang <wuqiang.matt@bytedance.com>
    kprobes: kretprobe events missing on 2-core KVM guest

Kees Cook <keescook@chromium.org>
    rtc: msc313: Fix function prototype mismatch in msc313_rtc_probe()

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: avoid scheduling in rtas_os_term()

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: avoid device tree lookups in rtas_os_term()

Ricardo Ribalda <ribalda@chromium.org>
    iommu/mediatek: Fix crash on isr after kexec()

Christophe Leroy <christophe.leroy@csgroup.eu>
    objtool: Fix SEGFAULT

Yin Xiujiang <yinxiujiang@kylinos.cn>
    fs/ntfs3: Fix slab-out-of-bounds in r_page

Dan Carpenter <dan.carpenter@oracle.com>
    fs/ntfs3: Delete duplicate condition in ntfs_read_mft()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fs/ntfs3: Use __GFP_NOWARN allocation at ntfs_fill_super()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fs/ntfs3: Use __GFP_NOWARN allocation at wnd_init()

Edward Lo <edward.lo@ambergroup.io>
    fs/ntfs3: Validate index root when initialize NTFS security

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: dmi-quirks: add quirk variant for LAPBC710 NUC15

Hawkins Jiawei <yin31149@gmail.com>
    fs/ntfs3: Fix slab-out-of-bounds read in run_unpack

Edward Lo <edward.lo@ambergroup.io>
    fs/ntfs3: Validate resident attribute name

Edward Lo <edward.lo@ambergroup.io>
    fs/ntfs3: Validate buffer length while parsing index

Edward Lo <edward.lo@ambergroup.io>
    fs/ntfs3: Validate attribute name offset

Edward Lo <edward.lo@ambergroup.io>
    fs/ntfs3: Add null pointer check for inode operations

Shigeru Yoshida <syoshida@redhat.com>
    fs/ntfs3: Fix memory leak on ntfs_fill_super() error path

Edward Lo <edward.lo@ambergroup.io>
    fs/ntfs3: Add null pointer check to attr_load_runs_vcn

Edward Lo <edward.lo@ambergroup.io>
    fs/ntfs3: Validate data run offset

edward lo <edward.lo@ambergroup.io>
    fs/ntfs3: Add overflow check for attribute size

edward lo <edward.lo@ambergroup.io>
    fs/ntfs3: Validate BOOT record_size

Christoph Hellwig <hch@lst.de>
    nvmet: don't defer passthrough commands with trivial effects to the workqueue

Christoph Hellwig <hch@lst.de>
    nvme: fix the NVME_CMD_EFFECTS_CSE_MASK definition

Adam Vodopjan <grozzly@protonmail.com>
    ata: ahci: Fix PCS quirk application for suspend

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix uaf for bfqq in bfq_exit_icq_bfqq

Adrian Freund <adrian@freund.io>
    ACPI: resource: do IRQ override on Lenovo 14ALC7

Erik Schumacher <ofenfisch@googlemail.com>
    ACPI: resource: do IRQ override on XMG Core 15

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    ACPI: resource: do IRQ override on LENOVO IdeaPad

Tamim Khan <tamim@fusetak.com>
    ACPI: resource: Skip IRQ override on Asus Vivobook K3402ZA/K3502ZA

Keith Busch <kbusch@kernel.org>
    nvme-pci: fix page size checks

Keith Busch <kbusch@kernel.org>
    nvme-pci: fix mempool alloc size

Klaus Jensen <k.jensen@samsung.com>
    nvme-pci: fix doorbell buffer value endianness

Paulo Alcantara <pc@cjr.nz>
    cifs: don't leak -ENOMEM in smb2_open_file()

Paulo Alcantara <pc@cjr.nz>
    cifs: fix static checker warning

Tejun Heo <tj@kernel.org>
    blk-iolatency: Fix memory leak on add_disk() failures

Christoph Hellwig <hch@lst.de>
    blk-cgroup: pass a gendisk to blkg_destroy_all

Christoph Hellwig <hch@lst.de>
    blk-throttle: pass a gendisk to blk_throtl_init and blk_throtl_exit

Christoph Hellwig <hch@lst.de>
    blk-cgroup: pass a gendisk to blkcg_init_queue and blkcg_exit_queue

Christoph Hellwig <hch@lst.de>
    blk-cgroup: cleanup the blkg_lookup family of functions

Christoph Hellwig <hch@lst.de>
    blk-cgroup: remove open coded blkg_lookup instances

Christoph Hellwig <hch@lst.de>
    blk-cgroup: remove blk_queue_root_blkg

Christoph Hellwig <hch@lst.de>
    blk-cgroup: fix error unwinding in blkcg_init_queue

Miaoqian Lin <linmq006@gmail.com>
    usb: dwc3: qcom: Fix memory leak in dwc3_qcom_interconnect_init


-------------

Diffstat:

 Documentation/trace/kprobes.rst   |   3 +-
 Makefile                          |   4 +-
 arch/powerpc/kernel/rtas.c        |  20 ++++++--
 block/bfq-iosched.c               |   2 +-
 block/blk-cgroup.c                | 100 ++++++++++++++------------------------
 block/blk-cgroup.h                |  68 ++++++++------------------
 block/blk-throttle.c              |   7 ++-
 block/blk-throttle.h              |   8 +--
 block/blk.h                       |   2 +-
 block/genhd.c                     |  12 +++--
 block/ioctl.c                     |  12 +++--
 drivers/acpi/resource.c           |  78 ++++++++++++++++++++++++-----
 drivers/ata/ahci.c                |  32 ++++++++----
 drivers/char/tpm/eventlog/acpi.c  |  12 +++--
 drivers/char/tpm/tpm_crb.c        |  29 +++++++----
 drivers/char/tpm/tpm_tis.c        |   9 ++--
 drivers/hid/hid-ids.h             |   3 ++
 drivers/hid/hid-multitouch.c      |   4 ++
 drivers/hid/hid-plantronics.c     |   9 ++++
 drivers/iommu/mtk_iommu.c         |   2 +-
 drivers/md/md.c                   |   9 ++--
 drivers/mfd/mt6360-core.c         |  14 +++++-
 drivers/mmc/host/vub300.c         |   2 +
 drivers/nvme/host/pci.c           |  37 +++++++-------
 drivers/nvme/target/passthru.c    |  11 ++---
 drivers/rtc/rtc-msc313.c          |  12 +----
 drivers/soundwire/dmi-quirks.c    |   8 +++
 drivers/usb/dwc3/dwc3-qcom.c      |  13 +++--
 fs/binfmt_elf_fdpic.c             |   5 +-
 fs/cifs/smb2file.c                |   4 +-
 fs/eventfd.c                      |  37 ++++++++------
 fs/eventpoll.c                    |  18 ++++---
 fs/f2fs/gc.c                      |   1 +
 fs/f2fs/node.c                    |   3 +-
 fs/hfsplus/hfsplus_fs.h           |   2 +
 fs/hfsplus/inode.c                |   4 +-
 fs/hfsplus/options.c              |   4 ++
 fs/ntfs3/attrib.c                 |  18 +++++++
 fs/ntfs3/attrlist.c               |   5 ++
 fs/ntfs3/bitmap.c                 |   2 +-
 fs/ntfs3/frecord.c                |  14 ++++++
 fs/ntfs3/fslog.c                  |  35 +++++--------
 fs/ntfs3/fsntfs.c                 |  10 ++--
 fs/ntfs3/index.c                  |   6 +++
 fs/ntfs3/inode.c                  |   9 ++++
 fs/ntfs3/record.c                 |  10 ++++
 fs/ntfs3/super.c                  |   9 ++--
 fs/overlayfs/dir.c                |  46 ++++++++++++------
 fs/overlayfs/file.c               |   1 +
 fs/pnode.c                        |   2 +-
 fs/pstore/ram.c                   |   2 +-
 fs/pstore/zone.c                  |   2 +-
 include/linux/eventfd.h           |   7 +++
 include/linux/nvme.h              |   3 +-
 include/uapi/linux/eventpoll.h    |   6 +++
 io_uring/io_uring.c               |   2 +-
 io_uring/msg_ring.c               |   4 --
 io_uring/opdef.c                  |   7 +++
 io_uring/opdef.h                  |   2 +
 kernel/futex/syscalls.c           |  11 +++--
 kernel/kcsan/core.c               |  50 +++++++++++++++++++
 kernel/kprobes.c                  |   8 +--
 kernel/locking/rtmutex.c          |  55 +++++++++++++++++----
 kernel/locking/rtmutex_api.c      |   6 +--
 mm/compaction.c                   |  18 ++-----
 mm/mempolicy.c                    |   1 +
 net/sunrpc/auth_gss/svcauth_gss.c |   9 +++-
 sound/pci/hda/patch_hdmi.c        |  27 +++++++---
 sound/usb/line6/driver.c          |   3 +-
 sound/usb/line6/midi.c            |   6 ++-
 sound/usb/line6/midibuf.c         |  25 +++++++---
 sound/usb/line6/midibuf.h         |   5 +-
 sound/usb/line6/pod.c             |   3 +-
 tools/objtool/check.c             |   2 +-
 74 files changed, 664 insertions(+), 367 deletions(-)


