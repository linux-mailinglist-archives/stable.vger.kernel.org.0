Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394B0523B71
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 19:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345497AbiEKRYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 13:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345488AbiEKRYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 13:24:24 -0400
Received: from email.studentenwerk.mhn.de (mailin.studentenwerk.mhn.de [141.84.225.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FD1222C34;
        Wed, 11 May 2022 10:24:21 -0700 (PDT)
Received: from mailhub.studentenwerk.mhn.de (mailhub.studentenwerk.mhn.de [127.0.0.1])
        by email.studentenwerk.mhn.de (Postfix) with ESMTPS id 4Kz1wz5snLzRhSb;
        Wed, 11 May 2022 19:24:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de; s=stwm-20170627;
        t=1652289859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k9eVYnLGKtxWt0XhKi1KPXkzEnwSkp1Vm3+xg83qKvc=;
        b=apTvmq+SUkRjjgX3IG1vu73T9oJ7ZaqTWmcCQNwI3CJUsZyQyc8ybomItHJny1lwrqtKtg
        HMi93IgbVqM8psuf5uaGPbFtebP6WoBpbnjFpcHbzvoYUIxNjDql0me9KoIcOaiM1YB8SF
        ONR9KhC4Q73WvVy9eo21hOg30eXwuMBhWMS1NaXNRsJ8ckYWQaWN4BvQFX5WEYmfNI7dTm
        kMpjjfSrp2Fv33Y/D+ThGbl6I4zxPbhqArXs2kiBSfsbmnpMKdtVsreqYs/5oM41r3aU/U
        N40FCMpmuJoSlDYlRthAI6AqGCok4KPqo89EKGbf4cAmQoT5uEXrThw8d4fFnQ==
MIME-Version: 1.0
Date:   Wed, 11 May 2022 19:24:23 +0200
From:   Wolfgang Walter <linux@stwm.de>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        linux-stable <stable@vger.kernel.org>,
        Trond Myklebust <trondmy@gmail.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 5.4.188 and later: massive performance regression with nfsd
In-Reply-To: <FC5DF233-1165-4733-8651-709BA021871E@oracle.com>
References: <f8d9b9112607df4807fba8948ac6e145@stwm.de>
 <YnuuLZe6h80KCNhd@kroah.com>
 <6A15DEE1-CAC9-4C64-8643-AD28EA423046@oracle.com>
 <YnvG71v4Ay560D+X@kroah.com>
 <0F5EA15D-08A0-4D3E-B5A9-D62C49BF2B56@oracle.com>
 <88e7fae3578052ba70eb3e8a3b929c54@stwm.de>
 <FC5DF233-1165-4733-8651-709BA021871E@oracle.com>
Message-ID: <8efeb7dde2bba548dc5b04787630dda3@stwm.de>
X-Sender: linux@stwm.de
Organization: =?UTF-8?Q?Studentenwerk_M=C3=BCnchen?=
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 2022-05-11 17:50, schrieb Chuck Lever III:
>> On May 11, 2022, at 11:30 AM, Wolfgang Walter <linux@stwm.de> wrote:
>> 
>> Am 2022-05-11 16:36, schrieb Chuck Lever III:
>>>> On May 11, 2022, at 10:23 AM, Greg KH <gregkh@linuxfoundation.org> 
>>>> wrote:
>>>> On Wed, May 11, 2022 at 02:16:19PM +0000, Chuck Lever III wrote:
>>>>>> On May 11, 2022, at 8:38 AM, Greg KH <gregkh@linuxfoundation.org> 
>>>>>> wrote:
>>>>>> On Wed, May 11, 2022 at 12:03:13PM +0200, Wolfgang Walter wrote:
>>>>>>> Hi,
>>>>>>> starting with 5.4.188 wie see a massive performance regression on 
>>>>>>> our
>>>>>>> nfs-server. It basically is serving requests very very slowly 
>>>>>>> with cpu
>>>>>>> utilization of 100% (with 5.4.187 and earlier it is 10%) so that 
>>>>>>> it is
>>>>>>> unusable as a fileserver.
>>>>>>> The culprit are commits (or one of it):
>>>>>>> c32f1041382a88b17da5736886da4a492353a1bb "nfsd: cleanup
>>>>>>> nfsd_file_lru_dispose()"
>>>>>>> 628adfa21815f74c04724abc85847f24b5dd1645 "nfsd: Containerise 
>>>>>>> filecache
>>>>>>> laundrette"
>>>>>>> (upstream 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63 and
>>>>>>> 9542e6a643fc69d528dfb3303f145719c61d3050)
>>>>>>> If I revert them in v5.4.192 the kernel works as before and 
>>>>>>> performance is
>>>>>>> ok again.
>>>>>>> I did not try to revert them one by one as any disruption of our 
>>>>>>> nfs-server
>>>>>>> is a severe problem for us and I'm not sure if they are related.
>>>>>>> 5.10 and 5.15 both always performed very badly on our nfs-server 
>>>>>>> in a
>>>>>>> similar way so we were stuck with 5.4.
>>>>>>> I now think this is because of 
>>>>>>> 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63
>>>>>>> and/or 9542e6a643fc69d528dfb3303f145719c61d3050 though I didn't 
>>>>>>> tried to
>>>>>>> revert them in 5.15 yet.
>>>>>> Odds are 5.18-rc6 is also a problem?
>>>>> We believe that
>>>>> 6b8a94332ee4 ("nfsd: Fix a write performance regression")
>>>>> addresses the performance regression. It was merged into 5.18-rc.
>>>> And into 5.17.4 if someone wants to try that release.
>>> I don't have a lot of time to backport this one myself, so
>>> I welcome anyone who wants to apply that commit to their
>>> favorite LTS kernel and test it for us.
>>>>>> If so, I'll just wait for the fix to get into Linus's tree as this 
>>>>>> does
>>>>>> not seem to be a stable-tree-only issue.
>>>>> Unfortunately I've received a recent report that the fix introduces
>>>>> a "sleep while spinlock is held" for NFSv4.0 in rare cases.
>>>> Ick, not good, any potential fixes for that?
>>> Not yet. I was at LSF last week, so I've just started digging
>>> into this one. I've confirmed that the report is a real bug,
>>> but we still don't know how hard it is to hit it with real
>>> workloads.
>>> --
>>> Chuck Lever
>> 
>> This maybe unrelated: when I used 5.4.188 for the first time I got 
>> this:
>> 
>> [Mon Apr 11 09:20:23 2022] ------------[ cut here ]------------
>> [Mon Apr 11 09:20:23 2022] refcount_t: underflow; use-after-free.
> 
> I don't believe this is the same issue as the performance
> regression. Hard to say more without knowing what the
> server's workload was when this occurred.
> 
> The only two NFSD-related patches that appear between
> v5.4.187 and v5.4.188 are Trond's filecache. It's implausible
> that a callback reference count issue would be related.


Maybe it is because of the high cpu load with these two patches. Whereas 
there are usually only 10 nfsd threads in R state even under high load 
and only for short times, with these two patches there are periods where 
there are 50 or more.

Our monitoring says that the load on average (1m) is < 1, with these two 
patches it was 18. So there is more parallelism.

> 
> 
>> [Mon Apr 11 09:20:23 2022] WARNING: CPU: 18 PID: 7443 at 
>> lib/refcount.c:190 refcount_sub_and_test_checked+0x48/0x50
>> [Mon Apr 11 09:20:23 2022] Modules linked in: rpcsec_gss_krb5(E) 
>> msr(E) 8021q(E) garp(E) stp(E) mrp(E) llc(E) dm_cache_smq(E) 
>> binfmt_misc(E) dm_cache(E) dm_persistent_data(E) dm_bio_prison(E) 
>> dm_bufio(E) ipmi_ssif(E) intel_rapl_ms
>> r(E) intel_rapl_common(E) sb_edac(E) x86_pkg_temp_thermal(E) 
>> intel_powerclamp(E) coretemp(E) kvm_intel(E) kvm(E) irqbypass(E) 
>> crct10dif_pclmul(E) crc32_pclmul(E) ast(E) snd_pcm(E) 
>> drm_vram_helper(E) ttm(E) ghash_clmulni_intel(E) s
>> nd_timer(E) rapl(E) snd(E) soundcore(E) drm_kms_helper(E) 
>> intel_cstate(E) pcspkr(E) iTCO_wdt(E) intel_uncore(E) drm(E) 
>> iTCO_vendor_support(E) mei_me(E) joydev(E) i2c_algo_bit(E) watchdog(E) 
>> mei(E) ioatdma(E) evdev(E) sg(E) ipmi_si
>> (E) ipmi_devintf(E) ipmi_msghandler(E) acpi_power_meter(E) acpi_pad(E) 
>> button(E) poly1305_x86_64(E) poly1305_generic(E) sha256_ssse3(E) 
>> sha1_ssse3(E) chacha_generic(E) chacha20poly1305(E) aesni_intel(E) 
>> crypto_simd(E) glue_helper(
>> E) cryptd(E) drbd(E) lru_cache(E) nfsd(E) nfs_acl(E) lockd(E) grace(E) 
>> auth_rpcgss(E) sunrpc(E)
>> [Mon Apr 11 09:20:23 2022]  ip_tables(E) x_tables(E) autofs4(E) 
>> ext4(E) crc16(E) mbcache(E) jbd2(E) dm_mod(E) raid10(E) raid456(E) 
>> async_raid6_recov(E) async_memcpy(E) async_pq(E) async_xor(E) 
>> async_tx(E) xor(E) raid6_pq(E) libcrc
>> 32c(E) crc32c_generic(E) raid0(E) multipath(E) linear(E) ses(E) 
>> enclosure(E) hid_generic(E) usbhid(E) hid(E) raid1(E) md_mod(E) 
>> sd_mod(E) crc32c_intel(E) ixgbe(E) ahci(E) xhci_pci(E) libahci(E) 
>> ehci_pci(E) xfrm_algo(E) mpt3sas(E)
>> xhci_hcd(E) ehci_hcd(E) dca(E) raid_class(E) libata(E) libphy(E) 
>> usbcore(E) scsi_transport_sas(E) lpc_ich(E) ptp(E) i2c_i801(E) 
>> mfd_core(E) usb_common(E) pps_core(E) scsi_mod(E) mdio(E) wmi(E)
>> [Mon Apr 11 09:20:23 2022] CPU: 18 PID: 7443 Comm: kworker/u50:1 
>> Tainted: G        W   E     5.4.188-debian64.all+1.2 #1
>> [Mon Apr 11 09:20:23 2022] Hardware name: Supermicro X10DRi/X10DRI-T, 
>> BIOS 1.1a 10/16/2015
>> [Mon Apr 11 09:20:23 2022] Workqueue: rpciod rpc_async_schedule 
>> [sunrpc]
>> [Mon Apr 11 09:20:23 2022] RIP: 
>> 0010:refcount_sub_and_test_checked+0x48/0x50
>> [Mon Apr 11 09:20:23 2022] Code: 31 e4 44 89 e0 41 5c c3 eb f8 44 0f 
>> b6 25 7c ee ce 00 45 84 e4 75 e8 48 c7 c7 80 97 8b b1 c6 05 69 ee ce 
>> 00 01 e8 78 3f 3a 00 <0f> 0b eb d4 0f 1f 40 00 48 89 fe bf 01 00 00 00 
>> eb a6 66 0f 1f 44
>> [Mon Apr 11 09:20:23 2022] RSP: 0018:ffffad8a8d01fe48 EFLAGS: 00010286
>> [Mon Apr 11 09:20:23 2022] RAX: 0000000000000000 RBX: 0000000000002a81 
>> RCX: 0000000000000000
>> [Mon Apr 11 09:20:23 2022] RDX: 0000000000000001 RSI: 0000000000000082 
>> RDI: 00000000ffffffff
>> [Mon Apr 11 09:20:23 2022] RBP: ffff9fb4a2394400 R08: 0000000000000001 
>> R09: 000000000000085b
>> [Mon Apr 11 09:20:23 2022] R10: 0000000000030f5c R11: 0000000000000004 
>> R12: 0000000000000000
>> [Mon Apr 11 09:20:23 2022] R13: ffff9feaf358d400 R14: 0000000000000000 
>> R15: ffff9fb7e1b25148
>> [Mon Apr 11 09:20:23 2022] FS:  0000000000000000(0000) 
>> GS:ffff9feaff980000(0000) knlGS:0000000000000000
>> [Mon Apr 11 09:20:23 2022] CS:  0010 DS: 0000 ES: 0000 CR0: 
>> 0000000080050033
>> [Mon Apr 11 09:20:23 2022] CR2: 00007ffe62ca3080 CR3: 000000350880a002 
>> CR4: 00000000001606e0
>> [Mon Apr 11 09:20:23 2022] Call Trace:
>> [Mon Apr 11 09:20:23 2022]  nfsd4_cb_offload_release+0x16/0x30 [nfsd]
>> [Mon Apr 11 09:20:23 2022]  rpc_free_task+0x39/0x70 [sunrpc]
>> [Mon Apr 11 09:20:23 2022]  rpc_async_schedule+0x29/0x40 [sunrpc]
>> [Mon Apr 11 09:20:23 2022]  process_one_work+0x1ab/0x390
>> [Mon Apr 11 09:20:23 2022]  worker_thread+0x50/0x3c0
>> [Mon Apr 11 09:20:23 2022]  ? rescuer_thread+0x370/0x370
>> [Mon Apr 11 09:20:23 2022]  kthread+0x13c/0x160
>> [Mon Apr 11 09:20:23 2022]  ? __kthread_bind_mask+0x60/0x60
>> [Mon Apr 11 09:20:23 2022]  ret_from_fork+0x1f/0x40
>> [Mon Apr 11 09:20:23 2022] ---[ end trace c58c1aaca9be5d21 ]---
>> [Mon Apr 11 09:56:32 2022] perf: interrupt took too long (6293 > 
>> 6228), lowering kernel.perf_event_max_sample_rate to 31750
>> [Mon Apr 11 09:59:17 2022] ------------[ cut here ]------------
> 
> 
> 
>> [Mon Apr 11 09:59:17 2022] nfsd4_process_open2 failed to open 
>> newly-created file! status=10008
> 
> This is definitely not the same problem. This is a failure
> to open a freshly created file. Maybe due to a memory shortage?

No, I don't think so, there was about 100G available.


> But this area has been a problem for a long time.
> 
> I have some patches going into 5.19 that might help in this
> area by making NFSv4 OPEN(CREATE) atomic.
> 
> 
>> [Mon Apr 11 09:59:17 2022] WARNING: CPU: 2 PID: 3061 at 
>> fs/nfsd/nfs4proc.c:456 nfsd4_open+0x39a/0x710 [nfsd]
>> [Mon Apr 11 09:59:17 2022] Modules linked in: rpcsec_gss_krb5(E) 
>> msr(E) 8021q(E) garp(E) stp(E) mrp(E) llc(E) dm_cache_smq(E) 
>> binfmt_misc(E) dm_cache(E) dm_persistent_data(E) dm_bio_prison(E) 
>> dm_bufio(E) ipmi_ssif(E) intel_rapl_msr(E) intel_rapl_common(E) 
>> sb_edac(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) 
>> kvm_intel(E) kvm(E) irqbypass(E) crct10dif_pclmul(E) crc32_pclmul(E) 
>> ast(E) snd_pcm(E) drm_vram_helper(E) ttm(E) ghash_clmulni_intel(E) 
>> snd_timer(E) rapl(E) snd(E) soundcore(E) drm_kms_helper(E) 
>> intel_cstate(E) pcspkr(E) iTCO_wdt(E) intel_uncore(E) drm(E) 
>> iTCO_vendor_support(E) mei_me(E) joydev(E) i2c_algo_bit(E) watchdog(E) 
>> mei(E) ioatdma(E) evdev(E) sg(E) ipmi_si(E) ipmi_devintf(E) 
>> ipmi_msghandler(E) acpi_power_meter(E) acpi_pad(E) button(E) 
>> poly1305_x86_64(E) poly1305_generic(E) sha256_ssse3(E) sha1_ssse3(E) 
>> chacha_generic(E) chacha20poly1305(E) aesni_intel(E) crypto_simd(E) 
>> glue_helper(E) cryptd(E) drbd(E) lru_cache(E) nfsd(E) nfs_acl(E) 
>> lockd(E) grace(E) auth_rpcgss(E) sunrpc(E)
>> [Mon Apr 11 09:59:17 2022]  ip_tables(E) x_tables(E) autofs4(E) 
>> ext4(E) crc16(E) mbcache(E) jbd2(E) dm_mod(E) raid10(E) raid456(E) 
>> async_raid6_recov(E) async_memcpy(E) async_pq(E) async_xor(E) 
>> async_tx(E) xor(E) raid6_pq(E) libcrc32c(E) crc32c_generic(E) raid0(E) 
>> multipath(E) linear(E) ses(E) enclosure(E) hid_generic(E) usbhid(E) 
>> hid(E) raid1(E) md_mod(E) sd_mod(E) crc32c_intel(E) ixgbe(E) ahci(E) 
>> xhci_pci(E) libahci(E) ehci_pci(E) xfrm_algo(E) mpt3sas(E) xhci_hcd(E) 
>> ehci_hcd(E) dca(E) raid_class(E) libata(E) libphy(E) usbcore(E) 
>> scsi_transport_sas(E) lpc_ich(E) ptp(E) i2c_i801(E) mfd_core(E) 
>> usb_common(E) pps_core(E) scsi_mod(E) mdio(E) wmi(E)
>> [Mon Apr 11 09:59:17 2022] CPU: 2 PID: 3061 Comm: nfsd Tainted: G      
>>   W   E     5.4.188-debian64.all+1.2 #1
>> [Mon Apr 11 09:59:17 2022] Hardware name: Supermicro X10DRi/X10DRI-T, 
>> BIOS 1.1a 10/16/2015
>> [Mon Apr 11 09:59:17 2022] RIP: 0010:nfsd4_open+0x39a/0x710 [nfsd]
>> [Mon Apr 11 09:59:17 2022] Code: e8 db 0f 01 00 41 89 c5 85 c0 0f 84 
>> 5e 01 00 00 80 bd 15 01 00 00 00 74 13 44 89 ee 48 c7 c7 a8 08 6f c0 
>> 0f ce e8 b6 f8 ae f0 <0f> 0b 4d 85 ff 0f 84 58 fd ff ff 4d 39 fc 0f 84 
>> 4f fd ff ff 4c 89
>> [Mon Apr 11 09:59:17 2022] RSP: 0018:ffffad8ab09c7db8 EFLAGS: 00010286
>> [Mon Apr 11 09:59:17 2022] RAX: 0000000000000000 RBX: ffff9feaaf7cb000 
>> RCX: 0000000000000000
>> [Mon Apr 11 09:59:17 2022] RDX: 0000000000000001 RSI: 0000000000000082 
>> RDI: 00000000ffffffff
>> [Mon Apr 11 09:59:17 2022] RBP: ffff9feaae54f460 R08: 0000000000000001 
>> R09: 000000000000087a
>> [Mon Apr 11 09:59:17 2022] R10: 0000000000031e00 R11: 0000000000000004 
>> R12: ffff9feaae550070
>> [Mon Apr 11 09:59:17 2022] R13: 0000000018270000 R14: ffff9feaae5ae000 
>> R15: ffff9fc07ccfd400
>> [Mon Apr 11 09:59:17 2022] FS:  0000000000000000(0000) 
>> GS:ffff9fcb1f880000(0000) knlGS:0000000000000000
>> [Mon Apr 11 09:59:17 2022] CS:  0010 DS: 0000 ES: 0000 CR0: 
>> 0000000080050033
>> [Mon Apr 11 09:59:17 2022] CR2: 00007fdae60db000 CR3: 00000037e87fe005 
>> CR4: 00000000001606e0
>> [Mon Apr 11 09:59:17 2022] Call Trace:
>> [Mon Apr 11 09:59:17 2022]  nfsd4_proc_compound+0x45d/0x730 [nfsd]
>> [Mon Apr 11 09:59:17 2022]  nfsd_dispatch+0xc1/0x200 [nfsd]
>> [Mon Apr 11 09:59:17 2022]  svc_process_common+0x399/0x6e0 [sunrpc]
>> [Mon Apr 11 09:59:17 2022]  ? svc_recv+0x312/0x9f0 [sunrpc]
>> [Mon Apr 11 09:59:17 2022]  ? nfsd_svc+0x2f0/0x2f0 [nfsd]
>> [Mon Apr 11 09:59:17 2022]  ? nfsd_destroy+0x60/0x60 [nfsd]
>> [Mon Apr 11 09:59:17 2022]  svc_process+0xd4/0x110 [sunrpc]
>> [Mon Apr 11 09:59:17 2022]  nfsd+0xed/0x150 [nfsd]
>> [Mon Apr 11 09:59:17 2022]  kthread+0x13c/0x160
>> [Mon Apr 11 09:59:17 2022]  ? __kthread_bind_mask+0x60/0x60
>> [Mon Apr 11 09:59:17 2022]  ret_from_fork+0x1f/0x40
>> [Mon Apr 11 09:59:17 2022] ---[ end trace c58c1aaca9be5d22 ]---
>> 
>> I never saw this with an earlier kernel (and we use 5.4 since a long 
>> time).
>> 
>> I did not see this with the unchanged 5.4.192, though, which I tested 
>> before running 5.4.192 with the above mentioned patches reverted.
>> 
>> Regards,
>> --
>> Wolfgang Walter
>> Studentenwerk München
>> Anstalt des öffentlichen Rechts
> 
> --
> Chuck Lever

-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
