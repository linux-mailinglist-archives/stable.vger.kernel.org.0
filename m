Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A136C89D
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 07:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfGRFOp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 18 Jul 2019 01:14:45 -0400
Received: from mo-csw1516.securemx.jp ([210.130.202.155]:48892 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfGRFOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 01:14:44 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id x6I5EBIn001477; Thu, 18 Jul 2019 14:14:11 +0900
X-Iguazu-Qid: 34tIVWg40pvgN7oHeE
X-Iguazu-QSIG: v=2; s=0; t=1563426850; q=34tIVWg40pvgN7oHeE; m=Eqgq3VB/9Z9kdnFI6J7I38+pKFpscUdEoKMTYnTKQwc=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1513) id x6I5E9HN020202;
        Thu, 18 Jul 2019 14:14:09 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id x6I5E9vc012518;
        Thu, 18 Jul 2019 14:14:09 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id x6I5E9cq021284;
        Thu, 18 Jul 2019 14:14:09 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGLbOI+5E0vBRQZuFEgFi8EHa9Hf3ioQVttE5HrEQzZDSZ3feDOoldXtwewAnVYLigTEOj2HeRxSUZEFMPK9SRqmTtVrjEFWU+oiWSc0QwkHWS02YSrGj+002/peMXnUo9+SVI+yb5lJ+a9YS31pPJ3h2im4OP4WfwCQlKLdGWsd9zBGNUkKCkspFbVSRiTo5glitZAd0IT+hi89XGqMkLcDntUWpmGH1FvKHHbWxdsL37zs0DB1odxLdLS/xCXO2zmxH/lfNFZKaPRS5ZrUzBrSe0CslvXi0XV+sNfuL8haYbZ35Uy2Mcyy4Um8pKHVmiwyj6x1E958JHHhIijTmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+oeKqeO5EIPp5OQc25k+oQ0s/nII4JEqgwhqINSTPw=;
 b=JFlY3YXj7M/bKMpp57KYcgWAhwJH9gzVEWRo6jeA7gaK2fflug4xFHgJd6p4zo7v39yBVga8Pg6SOMNpOg7G08N+E+4DjrfUMbnvxOUS+VLn2oVRhnjK90SECIhcJhWWSx5URC6LudYY8dA0bk6fDVQ+1d956kIC4HuyHA2pwly9/+NGPmC0tQeQIA40qJ7EkOt5H5ynE5WnTW3JocGFUXuJ/AB+xk74xSyDoBTTt8F2t27PA1RhUuSQo+cir5mxI3/atK1viHxR0Zz6F70g7d34jchOq05IbW8uZW9CK5e9lxwlvE30aDf1H44WDWcM5b+JJ0+93c2syS9NroXMQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=toshiba.co.jp;dmarc=pass action=none
 header.from=toshiba.co.jp;dkim=pass header.d=toshiba.co.jp;arc=none
From:   <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     <gregkh@linuxfoundation.org>
CC:     <devel@etsukata.com>, <rostedt@goodmis.org>,
        <stable@vger.kernel.org>
Subject: RE: [PATCH for 4.4, 4.9] tracing/snapshot: Resize spare buffer if
 size changed
Thread-Topic: [PATCH for 4.4, 4.9] tracing/snapshot: Resize spare buffer if
 size changed
Thread-Index: AQHVPRRi2d4vFUCJIEGeTfOY3YKBAabPsI+AgAAkK3A=
Date:   Thu, 18 Jul 2019 05:14:06 +0000
X-TSB-HOP: ON
Message-ID: <OSAPR01MB3234641B9227F34593012AF492C80@OSAPR01MB3234.jpnprd01.prod.outlook.com>
References: <156231680279219@kroah.com>
 <20190718025547.5550-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <20190718030323.GA3581@kroah.com>
In-Reply-To: <20190718030323.GA3581@kroah.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=nobuhiro1.iwamatsu@toshiba.co.jp; 
x-originating-ip: [124.211.28.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4af4169b-a404-40ad-29ec-08d70b3ec20e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:OSAPR01MB3668;
x-ms-traffictypediagnostic: OSAPR01MB3668:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <OSAPR01MB36683504720ED7247649BD2F92C80@OSAPR01MB3668.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:989;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(13464003)(199004)(189003)(6116002)(74316002)(8936002)(305945005)(3846002)(33656002)(6306002)(9686003)(55016002)(6246003)(4326008)(316002)(7736002)(68736007)(8676002)(54906003)(2906002)(53936002)(6436002)(186003)(26005)(102836004)(55236004)(966005)(66476007)(71190400001)(64756008)(486006)(71200400001)(53546011)(6506007)(66446008)(66556008)(66946007)(45080400002)(478600001)(46636005)(66066001)(81156014)(81166006)(5660300002)(76176011)(7696005)(25786009)(52536014)(476003)(14454004)(14444005)(256004)(6916009)(11346002)(446003)(86362001)(229853002)(99286004)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:OSAPR01MB3668;H:OSAPR01MB3234.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: toshiba.co.jp does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MdP+dHEUxiR1bAovvjbDcq2oYIRDKxrzKs7TJz5uWORkBRBtt0oFIsFU4f9LehIDHNkspQeJtKyyaLOlJ5WQmSFqjdXORyUIS2byQD0TpVCmxfAEhBl80Yep+HuWouNpLqwMGWzrgh0B7uvQFaCMjUWPtC/t/g4z1dSFGfJTc2q/Xxdcpcdp391gI9EIkqeeOeUbxWsJg3xfY5f2HK8M2q0UDhjUZ1yGSRAQnVr0UhQsjGWdHa/i6ul73T1goMUy0hiEQmLV3vyhqsww9EKga+dbFE1+95HmCcLC064OPNuaLVeoptRhC9B4oFQ5OhRbN8JPqJBUrpsapbjpoLQOrhJymlr7mViX2LMM96zHRi58qFIImAygRlxGScHqZjdH6beSJx9UM7UHLEMwWcK6fs+rvgCjTXQOwU2dX+DrQE4=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af4169b-a404-40ad-29ec-08d70b3ec20e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 05:14:06.5791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nobuhiro1.iwamatsu@toshiba.co.jp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB3668
MSSCP.TransferMailToMossAgent: 103
X-OriginatorOrg: toshiba.co.jp
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, July 18, 2019 12:03 PM
> To: iwamatsu nobuhiro(岩松 信洋 ○ＳＷＣ□ＯＳＴ)
> <nobuhiro1.iwamatsu@toshiba.co.jp>
> Cc: devel@etsukata.com; rostedt@goodmis.org; stable@vger.kernel.org
> Subject: Re: [PATCH for 4.4, 4.9] tracing/snapshot: Resize spare buffer
> if size changed
> 
> On Thu, Jul 18, 2019 at 11:55:47AM +0900, Nobuhiro Iwamatsu wrote:
> > From: Eiichi Tsukata <devel@etsukata.com>
> >
> > Current snapshot implementation swaps two ring_buffers even though
> > their sizes are different from each other, that can cause an
> > inconsistency between the contents of buffer_size_kb file and the
> current buffer size.
> >
> > For example:
> >
> >   # cat buffer_size_kb
> >   7 (expanded: 1408)
> >   # echo 1 > events/enable
> >   # grep bytes per_cpu/cpu0/stats
> >   bytes: 1441020
> >   # echo 1 > snapshot             // current:1408, spare:1408
> >   # echo 123 > buffer_size_kb     // current:123,  spare:1408
> >   # echo 1 > snapshot             // current:1408, spare:123
> >   # grep bytes per_cpu/cpu0/stats
> >   bytes: 1443700
> >   # cat buffer_size_kb
> >   123                             // != current:1408
> >
> > And also, a similar per-cpu case hits the following WARNING:
> >
> > Reproducer:
> >
> >   # echo 1 > per_cpu/cpu0/snapshot
> >   # echo 123 > buffer_size_kb
> >   # echo 1 > per_cpu/cpu0/snapshot
> >
> > WARNING:
> >
> >   WARNING: CPU: 0 PID: 1946 at kernel/trace/trace.c:1607
> update_max_tr_single.part.0+0x2b8/0x380
> >   Modules linked in:
> >   CPU: 0 PID: 1946 Comm: bash Not tainted 5.2.0-rc6 #20
> >   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.12.0-2.fc30 04/01/2014
> >   RIP: 0010:update_max_tr_single.part.0+0x2b8/0x380
> >   Code: ff e8 dc da f9 ff 0f 0b e9 88 fe ff ff e8 d0 da f9 ff 44 89
> ee bf f5 ff ff ff e8 33 dc f9 ff 41 83 fd f5 74 96 e8 b8 da f9 ff <0f>
> 0b eb 8d e8 af da f9 ff 0f 0b e9 bf fd ff ff e8 a3 da f9 ff 48
> >   RSP: 0018:ffff888063e4fca0 EFLAGS: 00010093
> >   RAX: ffff888066214380 RBX: ffffffff99850fe0 RCX: ffffffff964298a8
> >   RDX: 0000000000000000 RSI: 00000000fffffff5 RDI: 0000000000000005
> >   RBP: 1ffff1100c7c9f96 R08: ffff888066214380 R09: ffffed100c7c9f9b
> >   R10: ffffed100c7c9f9a R11: 0000000000000003 R12: 0000000000000000
> >   R13: 00000000ffffffea R14: ffff888066214380 R15: ffffffff99851060
> >   FS:  00007f9f8173c700(0000) GS:ffff88806d000000(0000)
> knlGS:0000000000000000
> >   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   CR2: 0000000000714dc0 CR3: 0000000066fa6000 CR4: 00000000000006f0
> >   Call Trace:
> >    ? trace_array_printk_buf+0x140/0x140
> >    ? __mutex_lock_slowpath+0x10/0x10
> >    tracing_snapshot_write+0x4c8/0x7f0
> >    ? trace_printk_init_buffers+0x60/0x60
> >    ? selinux_file_permission+0x3b/0x540
> >    ? tracer_preempt_off+0x38/0x506
> >    ? trace_printk_init_buffers+0x60/0x60
> >    __vfs_write+0x81/0x100
> >    vfs_write+0x1e1/0x560
> >    ksys_write+0x126/0x250
> >    ? __ia32_sys_read+0xb0/0xb0
> >    ? do_syscall_64+0x1f/0x390
> >    do_syscall_64+0xc1/0x390
> >    entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > This patch adds resize_buffer_duplicate_size() to check if there is
> a
> > difference between current/spare buffer sizes and resize a spare
> > buffer if necessary.
> >
> > Link:
> > http://lkml.kernel.org/r/20190625012910.13109-1-devel@etsukata.com
> >
> > Cc: stable@vger.kernel.org
> > Fixes: ad909e21bbe69 ("tracing: Add internal tracing_snapshot()
> > functions")
> > Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> > ---
> >  kernel/trace/trace.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> What is the git commit id of this patch in Linus's tree?
> 

Oh, sorry. I forgot it.
I will resend updated patch.	

Nobuhiro

