Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D14F2CF4
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 12:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfKGLFx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 7 Nov 2019 06:05:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:35144 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387725AbfKGLFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 06:05:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9D259B3F3;
        Thu,  7 Nov 2019 11:05:51 +0000 (UTC)
References: <cki.1210A7ECB0.BD9Q3APV4K@redhat.com> <2029139028.10333037.1572874551626.JavaMail.zimbra@redhat.com> <20191104135135.GA2162401@kroah.com> <1341418315.10342806.1572877690830.JavaMail.zimbra@redhat.com> <20191104145947.GA2211991@kroah.com> <251943262.10356408.1572881121044.JavaMail.zimbra@redhat.com> <20191104163033.GB2253150@kroah.com> <1766459302.10389172.1572886973921.JavaMail.zimbra@redhat.com> <20191104203239.GA2293927@kroah.com>
User-agent: mu4e 1.2.0; emacs 26.3
From:   Richard Palethorpe <rpalethorpe@suse.de>
To:     ltp@lists.linux.it
Cc:     Jan Stancek <jstancek@redhat.com>, alsa-devel@alsa-project.org,
        Memory Management <mm-qe@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Jaroslav Kysela <jkysela@redhat.com>,
        CKI Project <cki-project@redhat.com>
Subject: Re: [LTP]  =?utf-8?Q?=E2=9D=8C?= FAIL: Test report for kernel
 5.3.9-rc1-dfe283e.cki (stable)
Reply-To: rpalethorpe@suse.de
In-reply-to: <20191104203239.GA2293927@kroah.com>
Date:   Thu, 07 Nov 2019 12:05:51 +0100
Message-ID: <87k18cdjzk.fsf@rpws.prws.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Greg KH <gregkh@linuxfoundation.org> writes:

> On Mon, Nov 04, 2019 at 12:02:53PM -0500, Jan Stancek wrote:
>>
>> ----- Original Message -----
>> > On Mon, Nov 04, 2019 at 10:25:21AM -0500, Jan Stancek wrote:
>> > >
>> > > ----- Original Message -----
>> > > > On Mon, Nov 04, 2019 at 09:28:10AM -0500, Jan Stancek wrote:
>> > > > >
>> > > > >
>> > > > > ----- Original Message -----
>> > > > > > On Mon, Nov 04, 2019 at 08:35:51AM -0500, Jan Stancek wrote:
>> > > > > > >
>> > > > > > >
>> > > > > > > ----- Original Message -----
>> > > > > > > >
>> > > > > > > > Hello,
>> > > > > > > >
>> > > > > > > > We ran automated tests on a recent commit from this kernel tree:
>> > > > > > > >
>> > > > > > > >        Kernel repo:
>> > > > > > > >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>> > > > > > > >             Commit: dfe283e9fdac - Linux 5.3.9-rc1
>> > > > > > > >
>> > > > > > > > The results of these automated tests are provided below.
>> > > > > > > >
>> > > > > > > >     Overall result: FAILED (see details below)
>> > > > > > > >              Merge: OK
>> > > > > > > >            Compile: OK
>> > > > > > > >              Tests: FAILED
>> > > > > > > >
>> > > > > > > > All kernel binaries, config files, and logs are available for
>> > > > > > > > download
>> > > > > > > > here:
>> > > > > > > >
>> > > > > > > >   https://artifacts.cki-project.org/pipelines/262380
>> > > > > > > >
>> > > > > > > > One or more kernel tests failed:
>> > > > > > > >
>> > > > > > > >     x86_64:
>> > > > > > > >      ❌ LTP lite
>> > > > > > > >
>> > > > > > >
>> > > > > > > Not a 5.3 -stable regression.
>> > > > > > >
>> > > > > > > Failure comes from test that sanity checks all /proc files by doing
>> > > > > > > 1k read from each. There are couple issues it hits wrt. snd_hda_*.
>> > > > > > >
>> > > > > > > Example reproducer:
>> > > > > > >   dd if=/sys/kernel/debug/regmap/hdaudioC0D3-hdaudio/access
>> > > > > > >   of=out.txt
>> > > > > > >   count=1 bs=1024 iflag=nonblock
>> > > > > >
>> > > > > > That's not a proc file :)
>> > > > >
>> > > > > Right. It's same test that's used for /proc too.
>> > > > >
>> > > > > >
>> > > > > > > It's slow and triggers soft lockups [1]. And it also requires lot
>> > > > > > > of memory, triggering OOMs on smaller VMs:
>> > > > > > > 0x0000000024f0437b-0x000000001a32b1c8 1073745920
>> > > > > > > seq_read+0x131/0x400
>> > > > > > > pages=262144 vmalloc vpages N0=262144
>> > > > > > >
>> > > > > > > I'm leaning towards skipping all regmap entries in this test.
>> > > > > > > Comments are welcomed.
>> > > > > >
>> > > > > > Randomly poking around in debugfs is a sure way to cause crashes and
>> > > > > > major problems.  Also, debugfs files are NOT stable and only for
>> > > > > > debugging and should never be enabled on "real" systems.
>> > > > > >
>> > > > > > So what exactly is the test trying to do here?
>> > > > >
>> > > > > It's (unprivileged) user trying to open/read anything it can (/proc,
>> > > > > /sys)
>> > > > > to see if that triggers anything bad.
>> > > > >
>> > > > > It can run as privileged user too, which was the case above.
>> > > >
>> > > > Sure, you can do tons of bad things as root poking around in sysfs,
>> > > > debugfs, and procfs.  What exactly are you trying to do, break the
>> > > > system?
>> > >
>> > > We are talking about read-only here. Is it unreasonable to expect
>> > > that root can read all /proc entries without crashing the system?
>> >
>> > You are NOT reading /proc/ here.
>>
>> No. That was a general question to usefulness of privileged read,
>> using /proc as example where it commonly happens.
>>
>> > You are reading debugfs which you
>> > really have NOT idea what is in there.  As you saw, you are reading from
>> > hardware that is slow and doing odd things when you read from it.
>>
>> Agreed, I already sent a patch to LTP to blacklist it.
>
> Hopefully you are blacklisting all of debugfs.  and sysfs.  And procfs.
> Adding specific files back is fine, as long as you "know" they are ok
> and you are actually testing something valid there.
>
> thanks,
>
> greg k-h

TBH, most of the value of this test comes from being dumb and doing
things nobody thought to do because it would be stupid. It's an accident
that the test exists in the first place because I found some bugs in
older kernels naively trying to dump the contents of /sys.

It is useful to occasionally run this test as root in a VM where it
can't do any harm, even on debugfs and dev. We have detected missing
patches doing things like that which would probably be stopped by a sane
whitelist.

However I would agree that this creates too much noise for a CI under
normal circumstances. We could maybe add some meta-data to the test
saying it will create noise and freeze the SUT and in the future users
can specify what level of noise they are prepared to accept when
executing the LTP.

In the meantime, IMO, we can just force the test to switch to nobody by
default which it already does when reading /dev.

--
Thank you,
Richard.
