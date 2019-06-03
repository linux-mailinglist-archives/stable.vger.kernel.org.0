Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A345533954
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 21:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFCTyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 15:54:16 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45555 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfFCTyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 15:54:15 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jlu@pengutronix.de>)
        id 1hXt22-0003ST-Nc; Mon, 03 Jun 2019 21:54:10 +0200
Received: from localhost ([127.0.0.1])
        by ptx.hi.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <jlu@pengutronix.de>)
        id 1hXt22-0000mT-2E; Mon, 03 Jun 2019 21:54:10 +0200
Message-ID: <1559591648.29720.5.camel@pengutronix.de>
Subject: Re: [PATCHv3] fs/proc: allow reporting eip/esp for all coredumping
 threads
From:   Jan =?ISO-8859-1?Q?L=FCbbe?= <jlu@pengutronix.de>
Reply-To: jlu@pengutronix.de
To:     John Ogness <john.ogness@linutronix.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andy Lutomirski <luto@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Mon, 03 Jun 2019 21:54:08 +0200
In-Reply-To: <87pno0u59o.fsf_-_@linutronix.de>
References: <20190522161614.628-1-jlu@pengutronix.de>
         <875zpzif8v.fsf@linutronix.de>
         <20190525143220.e771b7915d17f22dad1438fa@linux-foundation.org>
         <87d0k5f1g7.fsf@linutronix.de> <87y32p7i7a.fsf@linutronix.de>
         <87pno0u59o.fsf_-_@linutronix.de>
Organization: Pengutronix
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2019-05-30 at 02:58 +0200, John Ogness wrote:
> Commit 0a1eb2d474ed ("fs/proc: Stop reporting eip and esp in
> /proc/PID/stat") stopped reporting eip/esp and commit fd7d56270b52
> ("fs/proc: Report eip/esp in /prod/PID/stat for coredumping")
> reintroduced the feature to fix a regression with userspace core dump
> handlers (such as minicoredumper).
> 
> Because PF_DUMPCORE is only set for the primary thread, this didn't fix
> the original problem for secondary threads. Allow reporting the eip/esp
> for all threads by checking for PF_EXITING as well. This is set for all
> the other threads when they are killed. coredump_wait() waits for all
> the tasks to become inactive before proceeding to invoke a core dumper.
> 
> Fixes: fd7d56270b526ca3 ("fs/proc: Report eip/esp in /prod/PID/stat for coredumping")
> Reported-by: Jan Luebbe <jlu@pengutronix.de>
> Signed-off-by: John Ogness <john.ogness@linutronix.de>

Tested-by: Jan Luebbe <jlu@pengutronix.de>

I've tested your patch and can confirm that eip/esp is accessible for
all threads again.

Thanks,
Jan
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
