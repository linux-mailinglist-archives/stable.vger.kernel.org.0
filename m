Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7014BED7A
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 23:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235855AbiBUWzb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 21 Feb 2022 17:55:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235524AbiBUWza (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 17:55:30 -0500
X-Greylist: delayed 533 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Feb 2022 14:55:06 PST
Received: from mxchg03.rrz.uni-hamburg.de (mxchg03.rrz.uni-hamburg.de [134.100.38.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD38E2459E
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 14:55:06 -0800 (PST)
X-Virus-Scanned: by University of Hamburg ( RRZ / mgw05.rrz.uni-hamburg.de )
Received: from exchange.uni-hamburg.de (UN-EX-MR08.uni-hamburg.de [134.100.84.75])
        by mxchg03.rrz.uni-hamburg.de (Postfix) with ESMTPS;
        Mon, 21 Feb 2022 23:46:11 +0100 (CET)
Received: from plasteblaster (89.244.206.97) by UN-EX-MR08.uni-hamburg.de
 (134.100.84.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 21 Feb
 2022 23:46:11 +0100
Date:   Mon, 21 Feb 2022 23:46:10 +0100
From:   "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Balbir Singh <bsingharora@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Sudip Mukherjee" <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH 5.4 32/80] taskstats: Cleanup the use of task->exit_code
Message-ID: <20220221234610.0d23e2e0@plasteblaster>
In-Reply-To: <20220221084916.628257481@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
        <20220221084916.628257481@linuxfoundation.org>
Organization: =?UTF-8?B?VW5pdmVyc2l0w6R0?= Hamburg
X-Mailer: Claws Mail (x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [89.244.206.97]
X-ClientProxiedBy: UN-EX-MR07.uni-hamburg.de (134.100.84.74) To
 UN-EX-MR08.uni-hamburg.de (134.100.84.75)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Mon, 21 Feb 2022 09:49:12 +0100
schrieb Greg Kroah-Hartman <gregkh@linuxfoundation.org>: 

> As best as I can figure the intent is to return task->exit_code after
> a task exits.  The field is returned with per task fields, so the
> exit_code of the entire process is not wanted.

I wondered about the use of exit_code, too, when preparing my patch
that introduces ac_tgid and the AGROUP flag to identify the first and
last tasks of a task group/process, see

	https://lkml.org/lkml/2022/2/18/887

With the information about the position of this task in the group,
users can take some meaning from the exit code (individual kills?). The
old style ensured that you got one exit code per process.

I addressing ac_exitcode fits together with my patch, while increasing
the version of taskstats helps clients that then can know that
ac_exitcode now has a different meaning. Right now this is a change
under the hood and you can just guess (or have to know from the kernel
version).


Alrighty then,

Thomas

-- 
Dr. Thomas Orgis
HPC @ Universität Hamburg
