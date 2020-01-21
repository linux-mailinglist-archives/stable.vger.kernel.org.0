Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD599144011
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 15:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAUO7k convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 21 Jan 2020 09:59:40 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:31426 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728186AbgAUO7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 09:59:40 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-219-L5SrfWfSPdmKcjEtPs885Q-1; Tue, 21 Jan 2020 14:59:36 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 21 Jan 2020 14:59:35 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 21 Jan 2020 14:59:35 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Peter Zijlstra' <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        "Anil S Keshavamurthy" <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Namhyung Kim <namhyung@kernel.org>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <thoiland@redhat.com>,
        "Jean-Tsung Hsiao" <jhsiao@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Masami Hiramatsu" <mhiramat@kernel.org>
Subject: RE: [for-linus][PATCH 2/5] tracing/uprobe: Fix double perf_event
 linking on multiprobe uprobe
Thread-Topic: [for-linus][PATCH 2/5] tracing/uprobe: Fix double perf_event
 linking on multiprobe uprobe
Thread-Index: AQHV0GolckT49KM4+0+Ui2RvGIz8QKf1NT6Q
Date:   Tue, 21 Jan 2020 14:59:35 +0000
Message-ID: <bd3126fff15641098af2a4ac2164f3c4@AcuMS.aculab.com>
References: <20200121143847.609307852@goodmis.org>
 <20200121143956.600928887@goodmis.org>
 <20200121145009.GR14879@hirez.programming.kicks-ass.net>
In-Reply-To: <20200121145009.GR14879@hirez.programming.kicks-ass.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: L5SrfWfSPdmKcjEtPs885Q-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra
> Sent: 21 January 2020 14:50
> On Tue, Jan 21, 2020 at 09:38:49AM -0500, Steven Rostedt wrote:
> > diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> > index 4ee703728aec..03e4e180058d 100644
> > --- a/kernel/trace/trace_probe.h
> > +++ b/kernel/trace/trace_probe.h
> > @@ -230,6 +230,7 @@ struct trace_probe_event {
> >  	struct trace_event_call		call;
> >  	struct list_head 		files;
> >  	struct list_head		probes;
> > +	char				data[0];
> >  };
> 
> Note that this relies on pure 'luck'. If you stick anything <4 bytes in
> between the list_head and the data member it'll come unstuck real fast.

Can you fix it by adding an unnamed struct as in:

struct trace_probe_event {
    	struct {
		struct trace_event_call		call;
		struct list_head 		files;
		struct list_head		probes;
	};
	char				data[0];
};

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

