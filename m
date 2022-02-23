Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86A34C1EB5
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 23:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbiBWWlB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 23 Feb 2022 17:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiBWWlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 17:41:00 -0500
Received: from mxchg04.rrz.uni-hamburg.de (mxchg04.rrz.uni-hamburg.de [134.100.38.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E8828D;
        Wed, 23 Feb 2022 14:40:30 -0800 (PST)
X-Virus-Scanned: by University of Hamburg ( RRZ / mgw04.rrz.uni-hamburg.de )
Received: from exchange.uni-hamburg.de (UN-EX-MR08.uni-hamburg.de [134.100.84.75])
        by mxchg04.rrz.uni-hamburg.de (Postfix) with ESMTPS;
        Wed, 23 Feb 2022 23:40:28 +0100 (CET)
Received: from plasteblaster (89.244.207.27) by UN-EX-MR08.uni-hamburg.de
 (134.100.84.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.18; Wed, 23 Feb
 2022 23:40:28 +0100
Date:   Wed, 23 Feb 2022 23:40:27 +0100
From:   "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH 5.4 32/80] taskstats: Cleanup the use of task->exit_code
Message-ID: <20220223234027.30566235@plasteblaster>
In-Reply-To: <87sfsa8nmf.fsf@email.froward.int.ebiederm.org>
References: <20220221084915.554151737@linuxfoundation.org>
        <20220221084916.628257481@linuxfoundation.org>
        <20220221234610.0d23e2e0@plasteblaster>
        <87sfsa8nmf.fsf@email.froward.int.ebiederm.org>
Organization: =?UTF-8?B?VW5pdmVyc2l0w6R0?= Hamburg
X-Mailer: Claws Mail (x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [89.244.207.27]
X-ClientProxiedBy: UN-EX-MR02.uni-hamburg.de (134.100.84.69) To
 UN-EX-MR08.uni-hamburg.de (134.100.84.75)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Tue, 22 Feb 2022 17:53:12 -0600
schrieb "Eric W. Biederman" <ebiederm@xmission.com>: 

> How do you figure?

I admit that I am struggling with understanding where exit codes come
from in the non-usual cases. During my taskstats tests, I played with
writing a multithreaded application that does call pthread_exit() in
the main thread (pid==tgid), for example. I slowly had to learn just
how messy this can be …

Is it clearly defined what the exitcode of a task as part of a process
is/should/can mean, as opposed to the process as a whole?

> For single-threaded processes ac_exitcode would always be reasonable,
> and be what userspace passed to exit(3).

Yes. That is the one case where we all know what we are dealing with;-)

> For multi-threaded processes ac_exitcode before my change was set to
> some completely arbitrary value for the thread whose tgid == tid.

Isn't the only place where it really makes sense to set the exitcode
when the last task of the process exits? I guess that was the intention
of the earlier code — with the same wrong assumption that I fell victim
to for quite some time: That the group leader (first task, tgid == pid)
always exits last.

I do not know in which cases group member threads have meaningful exit
codes different from the last one (which is the one returned for the
process in whole … ?). I'd love to see the exact reasoning on how
multithreading got mapped into kernel tasks which used to track only
single-threaded processes before.

> With my change the value returned
> is at least well defined.

But defined to what?

> Now maybe it would have been better to flag the bug fix with a version
> number.  Unfortunately I did not even realize taskstats had a version
> number.  I just know the code made no sense.

Well, fixing a bug that has been there from the beginning (of adding
multithreading, at least) is a significant change that one might want
to know about. And I do think that it fits to thouroughly fix these
issues that relate to identifying threads and processes (the shameless
plug of my taskstats patch that I'm working on since 2018, and only got
right in 2022, finally — I hope), while at that.


Alrighty then,

Thomas

-- 
Dr. Thomas Orgis
HPC @ Universität Hamburg
