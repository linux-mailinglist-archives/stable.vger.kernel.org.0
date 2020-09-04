Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F7D25DB3B
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 16:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730525AbgIDOTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 10:19:21 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:43782 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730578AbgIDOSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 10:18:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599229115; x=1630765115;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=BSmFllb3TFchMi2BNuBpi4nkiYO3Rid5SrJl2ZdO7Fg=;
  b=jj5/VxUpfrjDt+nLyTChGlMljEaSP/Na4PduEWP6sl2kOYlZJHEJx5m1
   CEOIQ5ROaq3pwdXDbu2hTRDZT+YZodpQZEO2oHT5vxsdONRJ/Yq971ALe
   Bf0VlIEt4YEzu7FoAIQI58gaA1T+sEYJh05f9Fh+PMzGCTVI0k/8+NMz0
   o=;
X-IronPort-AV: E=Sophos;i="5.76,389,1592870400"; 
   d="scan'208";a="72424632"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 04 Sep 2020 14:18:20 +0000
Received: from EX13D31EUA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id B348BA23CF;
        Fri,  4 Sep 2020 14:18:17 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.162.85) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Sep 2020 14:18:05 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     SeongJae Park <sjpark@amazon.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Filipe Manana <fdmanana@suse.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Taehee Yoo <ap420073@gmail.com>,
        Fabio Estevam <festevam@gmail.com>, Jan Kara <jack@suse.cz>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Adam Ford <aford173@gmail.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>, <sashal@kernel.org>,
        <amit@kernel.org>, <sj38.park@gmail.com>, <stable@vger.kernel.org>
Subject: Re: [5.4.y] Found 27 commits that might missed
Date:   Fri, 4 Sep 2020 16:17:48 +0200
Message-ID: <20200904141748.3658-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200904114935.GE2831752@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.85]
X-ClientProxiedBy: EX13D05UWC004.ant.amazon.com (10.43.162.223) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On   Fri, 4 Sep 2020 13:49:35 +0200   Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Aug 28, 2020 at 05:27:45PM +0200, SeongJae Park wrote:
> > From: SeongJae Park <sjpark@amazon.de>
> > 
> > Hello,
> > 
> > 
> > We found below 27 commits in the 'v5.5..linus/master (upstream)' seems fixing or mentioning
> > commits in the 'v5.4..stable/linux-5.4.y (downstream)' but are not merged in the 'downstream' yet.
> > Could you please review if those need to be merged in?
> > 
> > A commit is considered as fix of another if the complete 'Fixed:' tag is in the
> > commit message.  If the tag is not found but the commit message contains the
> > title or the hash id of the other commit, it is considered mentioning it.  So,
> > the 'mentions' might have many false positives, but it could cover the typos (I
> > found such cases before).
> > 
> > The commits are grouped as 'fixes cleanly applicable', 'fixes not cleanly
> > applicable (need manual backporting to be applied)', 'mentions cleanly
> > applicable', and 'mentions not cleanly applicable'.  Also, the commits in each
> > group are sorted by the commit dates (oldest first).
> > 
> > Both the finding of the commits and the writeup of this report is automatically
> > done by a little script[1].  I'm going to run the tool and post this kind of
> > report every couple of weeks or every month.  Any comment (e.g., regarding
> > posting period, new features request, bug report, ...) is welcome.
> > 
> > Especially, if you find some commits that don't need to be merged in the
> > downstream, please let me know so that I can mark those as unnecessary and
> > don't bother you again.
> > 
> > [1] https://github.com/sjp38/stream-track
> > 
> > 
> > Thanks,
> > SeongJae
> > 
> > 
> > # v5.5: 4e3112a240ba9986cc3f67a6880da6529a955006
> > # linus/master: 15bc20c6af4ceee97a1f90b43c0e386643c071b4
> > # v5.4: 6e815efe19a99a33b16cc720c3d3a727565a4fa1
> > # stable/linux-5.4.y: 6576d69aac94cd8409636dfa86e0df39facdf0d2
> > 
> > 
> > Fixes cleanly applicable
> > ------------------------
> > 
> > 2fb75ceaf71a ("remoteproc: Add missing '\n' in log messages")
> > # commit date: 2020-04-22, author: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > # fixes 'remoteproc: Fix NULL pointer dereference in rproc_virtio_notify'
> 
> Not a real fix, right?
> 
> > 1b9ae0c92925 ("wireless: Use linux/stddef.h instead of stddef.h")
> > # commit date: 2020-05-27, author: Hauke Mehrtens <hauke@hauke-m.de>
> > # fixes 'wireless: Use offsetof instead of custom macro.'
> 
> Is this really needed?
> 
> > e4b0e41fee94 ("ALSA: usb-audio: Use the new macro for HP Dock rename quirks")
> > # commit date: 2020-06-08, author: Takashi Iwai <tiwai@suse.de>
> > # fixes 'ALSA: usb-audio: Add vendor, product and profile name for HP Thunderbolt Dock'
> 
> Alsa stuff has been covered already...
> 
> > efb94790852a ("drm/panel-simple: fix connector type for LogicPD Type28 Display")
> > # commit date: 2020-06-21, author: Adam Ford <aford173@gmail.com>
> > # fixes 'drm/panel: simple: Add Logic PD Type 28 display support'
> 
> Why is this applicable to 5.4.y?  It says "5.6+" in the commit itself,
> right?
> 
> > 
> > 2f57b8d57673 ("dmaengine: imx-sdma: Fix: Remove 'always true' comparison")
> > # commit date: 2020-06-24, author: Fabio Estevam <festevam@gmail.com>
> > # fixes 'dmaengine: imx-sdma: Fix the event id check to include RX event for UART6'
> 
> Does not change any logic
> 
> > 
> > 10de795a5add ("kprobes: Fix compiler warning for !CONFIG_KPROBES_ON_FTRACE")
> > # commit date: 2020-08-06, author: Muchun Song <songmuchun@bytedance.com>
> > # fixes 'kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler'
> 
> Not needed, as mentioned.

Thanks for the review, I will apply those in the tool so that I never bother
you again with those.

> 
> > Fixes not cleanly applicable
> 
> <snip>
> 
> Stopping right here, if you have fixes that will not cleanly apply, and
> you think they should be applied, please fix them and send the proper
> backport.  I don't have the cycles to do these on my own.
> 
> Same for anything else here that you think should be applied but does
> not cleanly build/apply.

Totally agreed.  Actually, I posted a similar report[1] before and received
similar response.  I promised to back-port some of those by myself.  That's
still in my TODO list, but I was unable to get a time to revisit it quite long
time.  From this, I realized that it wouldn't be easy to review, test, and
backport all of the such suspicious things by myself.  Scaling up to multiple
stable series (the tool says there are 152 fixes and 147 mentions for 4.9.y)
seems impossible.

For the reason, I updated the tool to make the report to be sent to not only
the stable maintainers but also the authors of the suspicious commits, because
the review / test / backport of their own commits would be much easier that
others.  As a result, we were able to find one suspended commit:
https://lore.kernel.org/stable/CAKfTPtAkOes+HmVabRazhCBBUo0M+QW38q3Zzj_O3O+Ghvc1pA@mail.gmail.com/

Of course, I will use my spare time to gradually check the nobody checked
commits one by one.

So, I supposed you may read only the replies from the authors.  IOW, you're ok
to stop here or even above.  If even reading the replies from the authors is
also just a burden, I could report the summary, as I should summarize the
replies anyway, to make next report ignores the commits the others confirmed
not necessary for the stable@.

[1] https://lore.kernel.org/stable/20200629161542.GA683634@kroah.com/

> 
[...]
> > 
> > 
> > 
> > Mentions cleanly applicable
> > ---------------------------
> > 
> > 32ada3b9e04c ("x86/resctrl: Clean up unused function parameter in mkdir path")
> > # commit date: 2020-01-20, author: Xiaochen Shen <xiaochen.shen@intel.com>
> > # mentions 'x86/resctrl: Fix a deadlock due to inaccurate reference'
> > 
> > 20f513091caf ("crypto: ccree - remove set but not used variable 'du_size'")
> > # commit date: 2020-02-13, author: YueHaibing <yuehaibing@huawei.com>
> > # mentions 'crypto: ccree - fix FDE descriptor sequence'
> 
> Oh come on, why is this tripping anything?
> 
> Please read the patches and see if you think they make sense for a
> stable kernel, please tell me how the above one does?

So, as described above, 'mentions' could contain more false positives.  I may
try to improve the tool, but the report would still contain a large number of
false positives.  It's not aimed to replace other advanced tools like PatchNet
but to pick their rare mistakes.

Checking the false positives would be annoying, but I think it is possible if
the original authors helps together.  And, once a commit is reported as false
positive, the tool will not annoy people again (if there is no bug in the
tool).

As mentioned in the original mail, I'm going to send this kind of
report periodically.  Nonetheless, I'm doing this only in hope of making stable
series just a little bit more stable.  If you think this still makes no sense
but only makes you annoying, please let me know.  I could exclude you from the
recipients of this report and send you only authors opinions summarized one or
even simply stop generating and sending this kind of reports to stable@.


Thanks,
SeongJae Park
