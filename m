Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F46159561
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 17:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbgBKQxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 11:53:48 -0500
Received: from m9a0013g.houston.softwaregrp.com ([15.124.64.91]:45133 "EHLO
        m9a0013g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728188AbgBKQxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Feb 2020 11:53:47 -0500
X-Greylist: delayed 1532 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Feb 2020 11:53:47 EST
Received: FROM m9a0013g.houston.softwaregrp.com (15.121.0.190) BY m9a0013g.houston.softwaregrp.com WITH ESMTP
 FOR stable@vger.kernel.org;
 Tue, 11 Feb 2020 16:53:00 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 11 Feb 2020 16:20:47 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (15.124.8.13) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Tue, 11 Feb 2020 16:20:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7Ub7ginim675nP34eR7K+kttPgn/u54eo1EZ8kjYPuPlzILbJzBWJbBKAdZ2hfJY5MuseAUnt66bQgP4BeEgbEm7yFngNye8kj+hczz5CvqhY8jm6rU1zPZIK8QWRtDSzVoxexX2mVPBwI4vN/0lziDTT4RLUmGnV+rv9fmftvuil3xbbodbxpUYGYdGfCLKI1tJdoQotWjsIM1RGSUVxb9ncuQjkh4q9ETRMCri6Q00BI6najrCmBfpivxo2PlRy8VoCrxWizOBKMs+6ifIt9JWC6PXtfesUxqoFHd0vuNa3FqJo9Kp5cSAW/s89WltUFLKOci1Dbc2UYUNuD7ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DL76yyPg/PBz9jsyMvgW5JMbZ/xe/K3rvhEPGWULBMc=;
 b=dCg16l0toZIwVz5RJkmbmNthP8Frt2jg07D88ofDwJTUwziSmlr2svZwsaOANu7vmlTeSXS7zY7lNBoghKJE55DEilAGIZ676A7d/EXUft7XergMb+nCKtHo8kNGoKno9rD3k8VCL5R2BnQFL8r+PAyETd2AtXF9BlILCxBYIk4cIVXy1OtjStxS0DoalWaC1ZGP6cKihhIcH3GyB4BB4Xcoq9f0oAeTkz9FTN99Anl/k+0vX8vks6qSJZKiKVhczpl4lFzmWKlQRKz8wrghzqYXar3FjK6VJ52zFnSh+oAgaMoEPCy3nd6c/diBvvEeec74q1C8gKJ4jQxlQ+u4+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (10.255.237.204) by
 MN2PR18MB3278.namprd18.prod.outlook.com (10.255.237.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Tue, 11 Feb 2020 16:20:46 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::3050:6182:4666:6784]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::3050:6182:4666:6784%5]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 16:20:46 +0000
Subject: Re: [PATCH hulk-4.4-next 4/6] scsi: iscsi: Fix a potential deadlock
 in the timeout handler
To:     Ye Bin <yebin10@huawei.com>, <yanaijie@huawei.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@intel.com>,
        Chris Leech <cleech@redhat.com>, <stable@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20200211081516.28195-1-yebin10@huawei.com>
 <20200211081516.28195-5-yebin10@huawei.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <2d062baf-2a1e-f991-e83e-314ac615fb23@suse.com>
Date:   Tue, 11 Feb 2020 08:20:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200211081516.28195-5-yebin10@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0239.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::35) To MN2PR18MB3278.namprd18.prod.outlook.com
 (2603:10b6:208:168::12)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by LO2P265CA0239.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:b::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.23 via Frontend Transport; Tue, 11 Feb 2020 16:20:43 +0000
X-Originating-IP: [73.25.22.216]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cedbce4a-286d-4311-67f2-08d7af0e596b
X-MS-TrafficTypeDiagnostic: MN2PR18MB3278:
X-Microsoft-Antispam-PRVS: <MN2PR18MB32788A32EB564F796F8C25CEDA180@MN2PR18MB3278.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:221;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(189003)(199004)(31686004)(966005)(8936002)(52116002)(478600001)(186003)(2906002)(53546011)(54906003)(16576012)(16526019)(8676002)(316002)(81166006)(81156014)(26005)(86362001)(31696002)(6486002)(6666004)(36756003)(5660300002)(4326008)(956004)(66556008)(66476007)(2616005)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR18MB3278;H:MN2PR18MB3278.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mN4IvjFXzHMh6mP5Z8PlG7LwsRps4N+9J1zD4Kzyi8yrTc6+pnp2yIP+M9FkzvwYGEkGpdrilmsOqFfv5Bry3B8zw63+CFPORl8JOqq6t5C5Py7hstXmJVgB6v23AJnedtYgjwR3YcXiUzzUmkB3liTr1hxpJc5bEQXxkuxRYAS6DggSq4bkvbM0jON3b9SRSRPNnLRy9mfxGDbeIl/Wrc0QPXemD9jgjZNjl/FqLs+xstt5/XI1oDNBU4xlRIVH/zE7fBPO9cynpWOOVm99uwGkZy+/MW24ANrgdNW4Ox/rXowmJ2sQnNU5GNzfBafvyATxmDAQFAGx/GRbfrdddvIekMOoGEYudWdU/bbeq4h/u5BZP46HfKyZTjGkD/X9fxYKR4n6fQmpnWIrXvU8a0gh/y8PdZgF78V5vhrWadvJw1dmN+A+3VHoZswgGQ4V21FUku3Jr8viLzDcxO9bEhMBLGBMh6hrE1ejuV8dD+9bp8bXZC6/GuVZbnjF7iSZ7KpZf0mydFaBF45IPBtPsQ==
X-MS-Exchange-AntiSpam-MessageData: lmSFm8QFtChhZsDJbDbsuMnIyhASeSFAFh/RCB1adRQ95uxBaSDW59BTaaiWP+MsJLMytTwkbOJfFEYQzl/Hzch9wPNVec+F6QS59AgvplRhlz44vunsidWBXmUCbGpGjqqgUP+6WNk7oSvH1ShaqA==
X-MS-Exchange-CrossTenant-Network-Message-Id: cedbce4a-286d-4311-67f2-08d7af0e596b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 16:20:46.1898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AD3vgtJkK/9Fafa2YEK5R/1Y8BFN8fdk0SzS+uATKFuBC8//p61D9g6ZiVS+HkqIBMFdd+2xlhpaSpxSgmlBRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3278
X-OriginatorOrg: suse.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/11/20 12:15 AM, Ye Bin wrote:
> From: Bart Van Assche <bvanassche@acm.org>
> 
> mainline inclusion
> from mainline-v5.5-rc2~6^2~1
> commit 5480e299b5ae57956af01d4839c9fc88a465eeab
> category: bugfix
> bugzilla: 27543
> DTS: NA
> CVE: NA
> 
> -------------------------------------------------
> 
> Some time ago the block layer was modified such that timeout handlers are
> called from thread context instead of interrupt context. Make it safe to
> run the iSCSI timeout handler in thread context. This patch fixes the
> following lockdep complaint:
> 
> ================================
> WARNING: inconsistent lock state
> 5.5.1-dbg+ #11 Not tainted
> --------------------------------
> inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> kworker/7:1H/206 [HC0[0]:SC0[0]:HE1:SE1] takes:
> ffff88802d9827e8 (&(&session->frwd_lock)->rlock){+.?.}, at: iscsi_eh_cmd_timed_out+0xa6/0x6d0 [libiscsi]
> {IN-SOFTIRQ-W} state was registered at:
>   lock_acquire+0x106/0x240
>   _raw_spin_lock+0x38/0x50
>   iscsi_check_transport_timeouts+0x3e/0x210 [libiscsi]
>   call_timer_fn+0x132/0x470
>   __run_timers.part.0+0x39f/0x5b0
>   run_timer_softirq+0x63/0xc0
>   __do_softirq+0x12d/0x5fd
>   irq_exit+0xb3/0x110
>   smp_apic_timer_interrupt+0x131/0x3d0
>   apic_timer_interrupt+0xf/0x20
>   default_idle+0x31/0x230
>   arch_cpu_idle+0x13/0x20
>   default_idle_call+0x53/0x60
>   do_idle+0x38a/0x3f0
>   cpu_startup_entry+0x24/0x30
>   start_secondary+0x222/0x290
>   secondary_startup_64+0xa4/0xb0
> irq event stamp: 1383705
> hardirqs last  enabled at (1383705): [<ffffffff81aace5c>] _raw_spin_unlock_irq+0x2c/0x50
> hardirqs last disabled at (1383704): [<ffffffff81aacb98>] _raw_spin_lock_irq+0x18/0x50
> softirqs last  enabled at (1383690): [<ffffffffa0e2efea>] iscsi_queuecommand+0x76a/0xa20 [libiscsi]
> softirqs last disabled at (1383682): [<ffffffffa0e2e998>] iscsi_queuecommand+0x118/0xa20 [libiscsi]
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&(&session->frwd_lock)->rlock);
>   <Interrupt>
>     lock(&(&session->frwd_lock)->rlock);
> 
>  *** DEADLOCK ***
> 
> 2 locks held by kworker/7:1H/206:
>  #0: ffff8880d57bf928 ((wq_completion)kblockd){+.+.}, at: process_one_work+0x472/0xab0
>  #1: ffff88802b9c7de8 ((work_completion)(&q->timeout_work)){+.+.}, at: process_one_work+0x476/0xab0
> 
> stack backtrace:
> CPU: 7 PID: 206 Comm: kworker/7:1H Not tainted 5.5.1-dbg+ #11
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> Workqueue: kblockd blk_mq_timeout_work
> Call Trace:
>  dump_stack+0xa5/0xe6
>  print_usage_bug.cold+0x232/0x23b
>  mark_lock+0x8dc/0xa70
>  __lock_acquire+0xcea/0x2af0
>  lock_acquire+0x106/0x240
>  _raw_spin_lock+0x38/0x50
>  iscsi_eh_cmd_timed_out+0xa6/0x6d0 [libiscsi]
>  scsi_times_out+0xf4/0x440 [scsi_mod]
>  scsi_timeout+0x1d/0x20 [scsi_mod]
>  blk_mq_check_expired+0x365/0x3a0
>  bt_iter+0xd6/0xf0
>  blk_mq_queue_tag_busy_iter+0x3de/0x650
>  blk_mq_timeout_work+0x1af/0x380
>  process_one_work+0x56d/0xab0
>  worker_thread+0x7a/0x5d0
>  kthread+0x1bc/0x210
>  ret_from_fork+0x24/0x30
> 
> Fixes: 287922eb0b18 ("block: defer timeouts to a workqueue")
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Lee Duncan <lduncan@suse.com>
> Cc: Chris Leech <cleech@redhat.com>
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20191209173457.187370-1-bvanassche@acm.org
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  drivers/scsi/libiscsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 0fdc8c417035..b4fbcf4cade8 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1982,7 +1982,7 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
>  
>  	ISCSI_DBG_EH(session, "scsi cmd %p timedout\n", sc);
>  
> -	spin_lock(&session->frwd_lock);
> +	spin_lock_bh(&session->frwd_lock);
>  	task = (struct iscsi_task *)sc->SCp.ptr;
>  	if (!task) {
>  		/*
> @@ -2109,7 +2109,7 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
>  done:
>  	if (task)
>  		task->last_timeout = jiffies;
> -	spin_unlock(&session->frwd_lock);
> +	spin_unlock_bh(&session->frwd_lock);
>  	ISCSI_DBG_EH(session, "return %s\n", rc == BLK_EH_RESET_TIMER ?
>  		     "timer reset" : "shutdown or nh");
>  	return rc;
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>
