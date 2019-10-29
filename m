Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACB6E7E94
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 03:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbfJ2Cjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 22:39:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46907 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729320AbfJ2Cjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 22:39:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572316785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RAd+DgcdhRwP0cS60cLWy9q+urmFL/vvanQl/KPL3KU=;
        b=fIKDJyq3Rx6h5KAzx+S3nCYwmGKzJ91vZ2tenTC2hknXCluLCPe81mSgmcFzUQqI5KcB5y
        0XSDuXHE9bXjxou1fxpCy8OSwBoD+V6IqX/L6YJACKaAp/2FT4ZeGj4lkgxHauFc3pQ1ij
        1ptk7QCxhpAQzUPBZUeBfWMiy2fhXLE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-DSPfKqsWPHO8aCm-xIylsQ-1; Mon, 28 Oct 2019 22:39:43 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EEBA8017CC
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 02:39:42 +0000 (UTC)
Received: from localhost (dhcp-12-196.nay.redhat.com [10.66.12.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF0C7600C1;
        Tue, 29 Oct 2019 02:39:34 +0000 (UTC)
Date:   Tue, 29 Oct 2019 10:39:33 +0800
From:   Murphy Zhou <xzhou@redhat.com>
To:     Rachel Sibley <rasibley@redhat.com>
Cc:     Memory Management <mm-qe@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Yi Zhang <yi.zhang@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.3.8-rc1-740177d.cki (stable)
Message-ID: <20191029023933.kfltsv2bbel5x6a4@xzhoux.usersys.redhat.com>
References: <cki.944DA2AA5D.T2W6XE1PPV@redhat.com>
 <d0684d9e-5a89-1d7f-2e00-40143f07c06b@redhat.com>
MIME-Version: 1.0
In-Reply-To: <d0684d9e-5a89-1d7f-2e00-40143f07c06b@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: DSPfKqsWPHO8aCm-xIylsQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 28, 2019 at 10:19:06AM -0400, Rachel Sibley wrote:
> Xiong, the generic/402 test is failing for both ext4/xfs tests with upstr=
eam kernels, including
> previous reports. Is this a test issue related to moving to F31 distro or=
 something else ?

generic/402 has been updated last week as the y2038 fs part has been
merged into Linux upstream:

https://git.kernel.org/torvalds/c/cfb82e1df8b7c76991ea12958855897c2fb4debc

cfb82e1df8b7 Merge tag 'y2038-vfs' of git://git.kernel.org/pub/scm/linux/ke=
rnel/git/arnd/playground

$ git describe --contains cfb82e1df8b7
v5.4-rc1~119

I guess kernel needs this patchset to pass the testcase.

Thanks,
Xiong

> Also, the kaslr memory test is failing, but I have seen it fail in previo=
us upstream reports,
> hoping someone from the MM-QE@ team can follow up here ?
>=20
> Thanks,
> Rachel
> Running test generic/402
> #! /bin/bash
> # SPDX-License-Identifier: GPL-2.0
> # Copyright (c) 2016 Deepa Dinamani.  All Rights Reserved.
> #
> # FS QA Test 402
> #
> # Test to verify filesystem timestamps for supported ranges.
> #
> # Exit status 1: test failed.
> # Exit status 0: test passed.
> FSTYP         -- ext4
> PLATFORM      -- Linux/aarch64 apm-mustang-ev3-31 5.3.8-rc1-740177d.cki #=
1 SMP Sun Oct 27 20:49:25 UTC 2019
> MKFS_OPTIONS  -- /dev/sda4
> MOUNT_OPTIONS -- -o acl,user_xattr -o context=3Dsystem_u:object_r:nfs_t:s=
0 /dev/sda4 /mnt/xfstests/mnt2
>=20
> generic/402=09- output mismatch (see /var/lib/xfstests/results//generic/4=
02.out.bad)
>     --- tests/generic/402.out=092019-10-27 17:58:14.916322247 -0400
>     +++ /var/lib/xfstests/results//generic/402.out.bad=092019-10-27 18:14=
:39.392150403 -0400
>     @@ -1,2 +1,4 @@
>      QA output created by 402
>     +15032385535;15032385535 !=3D 15032385536;15032385536
>     +15032385535;15032385535 !=3D -2147483648;-2147483648
>      Silence is golden
>     ...
>     (Run 'diff -u /var/lib/xfstests/tests/generic/402.out /var/lib/xfstes=
ts/results//generic/402.out.bad'  to see the entire diff)
> Ran: generic/402
> Failures: generic/402
> Failed 1 of 1 tests
>=20
> Uploading generic-402.full .done
> Uploading generic-402.out.bad .done
> Uploading generic-402.out.bad.diff .done
> ** ext4:generic/402 FAIL Score:0
> Uploading resultoutputfile.log .done
>=20
>=20
> :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::=
:::::::
> ::   kaslr-compare
> :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::=
:::::::
>=20
> :: [ 19:02:29 ] :: [   PASS   ] :: to next state after_r_nokaslr_snapshot=
 (Expected 0, got 0)
> :: [ 19:02:29 ] :: [   FAIL   ] :: _text should be non-default (Assert: "=
ffffffff81000000" should not equal "ffffffff81000000")
> :: [ 19:02:30 ] :: [   PASS   ] :: Kernel_code should be non-default (Ass=
ert: "01000000" should not equal "8d000000")
>=20
>=20
> :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::=
:::::::
> ::   kaslr-compare
> :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::=
:::::::
>=20
> :: [ 19:02:29 ] :: [   PASS   ] :: to next state after_r_nokaslr_snapshot=
 (Expected 0, got 0)
> :: [ 19:02:29 ] :: [   FAIL   ] :: _text should be non-default (Assert: "=
ffffffff81000000" should not equal "ffffffff81000000")
>=20
> On 10/27/19 11:26 PM, CKI Project wrote:
> > Hello,
> >=20
> > We ran automated tests on a recent commit from this kernel tree:
> >=20
> >         Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stab=
le/linux-stable-rc.git
> >              Commit: 740177dc0d52 - Linux 5.3.8-rc1
> >=20
> > The results of these automated tests are provided below.
> >=20
> >      Overall result: FAILED (see details below)
> >               Merge: OK
> >             Compile: OK
> >               Tests: FAILED
> >=20
> > All kernel binaries, config files, and logs are available for download =
here:
> >=20
> >    https://artifacts.cki-project.org/pipelines/251766
> >=20
> > One or more kernel tests failed:
> >=20
> >      ppc64le:
> >       =E2=9D=8C xfstests: ext4
> >       =E2=9D=8C xfstests: xfs
> >=20
> >      aarch64:
> >       =E2=9D=8C xfstests: ext4
> >       =E2=9D=8C xfstests: xfs
> >=20
> >      x86_64:
> >       =E2=9D=8C Memory function: kaslr
> >       =E2=9D=8C xfstests: ext4
> >       =E2=9D=8C xfstests: xfs
> >=20
> > We hope that these logs can help you find the problem quickly. For the =
full
> > detail on our testing procedures, please scroll to the bottom of this m=
essage.
> >=20
> > Please reply to this email if you have any questions about the tests th=
at we
> > ran or if you have any suggestions on how to make future tests more eff=
ective.
> >=20
> >          ,-.   ,-.
> >         ( C ) ( K )  Continuous
> >          `-',-.`-'   Kernel
> >            ( I )     Integration
> >             `-'
> > _______________________________________________________________________=
_______
> >=20
> > Compile testing
> > ---------------
> >=20
> > We compiled the kernel for 3 architectures:
> >=20
> >      aarch64:
> >        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> >=20
> >      ppc64le:
> >        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> >=20
> >      x86_64:
> >        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> >=20
> >=20
> > Hardware testing
> > ----------------
> > We booted each kernel and ran the following tests:
> >=20
> >    aarch64:
> >      Host 1:
> >         =E2=9C=85 Boot test
> >         =E2=9D=8C xfstests: ext4
> >         =E2=9D=8C xfstests: xfs
> >         =E2=9C=85 selinux-policy: serge-testsuite
> >         =E2=9C=85 lvm thinp sanity
> >         =E2=9C=85 storage: software RAID testing
> >         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
> >=20
> >      Host 2:
> >         =E2=9C=85 Boot test
> >         =E2=9C=85 Podman system integration test (as root)
> >         =E2=9C=85 Podman system integration test (as user)
> >         =E2=9C=85 LTP lite
> >         =E2=9C=85 Loopdev Sanity
> >         =E2=9C=85 jvm test suite
> >         =E2=9C=85 Memory function: memfd_create
> >         =E2=9C=85 Memory function: kaslr
> >         =E2=9C=85 AMTU (Abstract Machine Test Utility)
> >         =E2=9C=85 LTP: openposix test suite
> >         =E2=9C=85 Ethernet drivers sanity
> >         =E2=9C=85 Networking MACsec: sanity
> >         =E2=9C=85 Networking socket: fuzz
> >         =E2=9C=85 Networking sctp-auth: sockopts test
> >         =E2=9C=85 Networking: igmp conformance test
> >         =E2=9C=85 Networking route: pmtu
> >         =E2=9C=85 Networking TCP: keepalive test
> >         =E2=9C=85 Networking UDP: socket
> >         =E2=9C=85 Networking tunnel: geneve basic test
> >         =E2=9C=85 Networking tunnel: gre basic
> >         =E2=9C=85 Networking tunnel: vxlan basic
> >         =E2=9C=85 audit: audit testsuite test
> >         =E2=9C=85 httpd: mod_ssl smoke sanity
> >         =E2=9C=85 iotop: sanity
> >         =E2=9C=85 tuned: tune-processes-through-perf
> >         =E2=9C=85 ALSA PCM loopback test
> >         =E2=9C=85 ALSA Control (mixer) Userspace Element test
> >         =E2=9C=85 Usex - version 1.9-29
> >         =E2=9C=85 storage: SCSI VPD
> >         =E2=9C=85 stress: stress-ng
> >         =E2=9C=85 trace: ftrace/tracer
> >         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
> >         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
> >         =F0=9F=9A=A7 =E2=9C=85 Networking bridge: sanity
> >         =F0=9F=9A=A7 =E2=9C=85 Networking route_func: local
> >         =E2=9C=85 Networking route_func: forward
> >         =F0=9F=9A=A7 =E2=9C=85 L2TP basic test
> >         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
> >         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
> >         =F0=9F=9A=A7 =E2=9C=85 Networking ipsec: basic netns transport
> >         =F0=9F=9A=A7 =E2=9C=85 Networking ipsec: basic netns tunnel
> >=20
> >    ppc64le:
> >      Host 1:
> >         =E2=9C=85 Boot test
> >         =E2=9D=8C xfstests: ext4
> >         =E2=9D=8C xfstests: xfs
> >         =E2=9C=85 selinux-policy: serge-testsuite
> >         =E2=9C=85 lvm thinp sanity
> >         =E2=9C=85 storage: software RAID testing
> >         =F0=9F=9A=A7 =E2=9C=85 Storage blktests
> >=20
> >      Host 2:
> >         =E2=9C=85 Boot test
> >         =E2=9C=85 Podman system integration test (as root)
> >         =E2=9C=85 Podman system integration test (as user)
> >         =E2=9C=85 LTP lite
> >         =E2=9C=85 Loopdev Sanity
> >         =E2=9C=85 jvm test suite
> >         =E2=9C=85 Memory function: memfd_create
> >         =E2=9C=85 Memory function: kaslr
> >         =E2=9C=85 AMTU (Abstract Machine Test Utility)
> >         =E2=9C=85 LTP: openposix test suite
> >         =E2=9C=85 Ethernet drivers sanity
> >         =E2=9C=85 Networking MACsec: sanity
> >         =E2=9C=85 Networking socket: fuzz
> >         =E2=9C=85 Networking sctp-auth: sockopts test
> >         =E2=9C=85 Networking route: pmtu
> >         =E2=9C=85 Networking TCP: keepalive test
> >         =E2=9C=85 Networking UDP: socket
> >         =E2=9C=85 Networking tunnel: geneve basic test
> >         =E2=9C=85 Networking tunnel: gre basic
> >         =E2=9C=85 Networking tunnel: vxlan basic
> >         =E2=9C=85 audit: audit testsuite test
> >         =E2=9C=85 httpd: mod_ssl smoke sanity
> >         =E2=9C=85 iotop: sanity
> >         =E2=9C=85 tuned: tune-processes-through-perf
> >         =E2=9C=85 ALSA PCM loopback test
> >         =E2=9C=85 ALSA Control (mixer) Userspace Element test
> >         =E2=9C=85 Usex - version 1.9-29
> >         =E2=9C=85 trace: ftrace/tracer
> >         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
> >         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
> >         =F0=9F=9A=A7 =E2=9C=85 Networking bridge: sanity
> >         =F0=9F=9A=A7 =E2=9C=85 Networking route_func: local
> >         =E2=9C=85 Networking route_func: forward
> >         =F0=9F=9A=A7 =E2=9C=85 L2TP basic test
> >         =F0=9F=9A=A7 =E2=9C=85 Networking ipsec: basic netns tunnel
> >         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
> >         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
> >=20
> >    x86_64:
> >      Host 1:
> >         =E2=9C=85 Boot test
> >         =F0=9F=9A=A7 =E2=9C=85 IPMI driver test
> >         =F0=9F=9A=A7 =E2=9C=85 IPMItool loop stress test
> >=20
> >      Host 2:
> >=20
> >         =E2=9A=A1 Internal infrastructure issues prevented one or more =
tests (marked
> >         with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architec=
ture.
> >         This is not the fault of the kernel that was tested.
> >=20
> >         =E2=9C=85 Boot test
> >         =E2=9C=85 Podman system integration test (as root)
> >         =E2=9C=85 Podman system integration test (as user)
> >         =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP lite
> >         =E2=9C=85 Loopdev Sanity
> >         =E2=9C=85 jvm test suite
> >         =E2=9C=85 Memory function: memfd_create
> >         =E2=9D=8C Memory function: kaslr
> >         =E2=9C=85 AMTU (Abstract Machine Test Utility)
> >         =E2=9C=85 LTP: openposix test suite
> >         =E2=9C=85 Ethernet drivers sanity
> >         =E2=9C=85 Networking MACsec: sanity
> >         =E2=9C=85 Networking socket: fuzz
> >         =E2=9C=85 Networking sctp-auth: sockopts test
> >         =E2=9C=85 Networking: igmp conformance test
> >         =E2=9C=85 Networking route: pmtu
> >         =E2=9C=85 Networking TCP: keepalive test
> >         =E2=9C=85 Networking UDP: socket
> >         =E2=9C=85 Networking tunnel: geneve basic test
> >         =E2=9C=85 Networking tunnel: gre basic
> >         =E2=9C=85 Networking tunnel: vxlan basic
> >         =E2=9C=85 audit: audit testsuite test
> >         =E2=9C=85 httpd: mod_ssl smoke sanity
> >         =E2=9C=85 iotop: sanity
> >         =E2=9C=85 tuned: tune-processes-through-perf
> >         =E2=9C=85 pciutils: sanity smoke test
> >         =E2=9C=85 ALSA PCM loopback test
> >         =E2=9C=85 ALSA Control (mixer) Userspace Element test
> >         =E2=9C=85 Usex - version 1.9-29
> >         =E2=9C=85 storage: SCSI VPD
> >         =E2=9C=85 stress: stress-ng
> >         =E2=9C=85 trace: ftrace/tracer
> >         =F0=9F=9A=A7 =E2=9C=85 CIFS Connectathon
> >         =F0=9F=9A=A7 =E2=9C=85 POSIX pjd-fstest suites
> >         =F0=9F=9A=A7 =E2=9C=85 Networking bridge: sanity
> >         =F0=9F=9A=A7 =E2=9C=85 Networking route_func: local
> >         =E2=9C=85 Networking route_func: forward
> >         =F0=9F=9A=A7 =E2=9C=85 L2TP basic test
> >         =F0=9F=9A=A7 =E2=9C=85 Networking vnic: ipvlan/basic
> >         =F0=9F=9A=A7 =E2=9C=85 storage: dm/common
> >         =F0=9F=9A=A7 =E2=9C=85 Networking ipsec: basic netns transport
> >         =F0=9F=9A=A7 =E2=9C=85 Networking ipsec: basic netns tunnel
> >=20
> >      Host 3:
> >         =E2=9C=85 Boot test
> >         =E2=9D=8C xfstests: ext4
> >         =E2=9D=8C xfstests: xfs
> >         =E2=9C=85 selinux-policy: serge-testsuite
> >         =E2=9C=85 lvm thinp sanity
> >         =E2=9C=85 storage: software RAID testing
> >         =F0=9F=9A=A7 =E2=9C=85 IOMMU boot test
> >         =F0=9F=9A=A7 =E2=9D=8C Storage blktests
> >=20
> >    Test sources: https://github.com/CKI-project/tests-beaker
> >      =F0=9F=92=9A Pull requests are welcome for new tests or improvemen=
ts to existing tests!
> >=20
> > Waived tests
> > ------------
> > If the test run included waived tests, they are marked with =F0=9F=9A=
=A7. Such tests are
> > executed but their results are not taken into account. Tests are waived=
 when
> > their results are not reliable enough, e.g. when they're just introduce=
d or are
> > being fixed.
> >=20
> > Testing timeout
> > ---------------
> > We aim to provide a report within reasonable timeframe. Tests that have=
n't
> > finished running are marked with =E2=8F=B1. Reports for non-upstream ke=
rnels have
> > a Beaker recipe linked to next to each host.
> >=20
>=20

