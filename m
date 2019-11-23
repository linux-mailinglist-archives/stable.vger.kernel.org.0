Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF59107D45
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 07:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfKWGOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Nov 2019 01:14:54 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:24406 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfKWGOx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Nov 2019 01:14:53 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id xAN6EkhW015142;
        Sat, 23 Nov 2019 07:14:46 +0100
Date:   Sat, 23 Nov 2019 07:14:46 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Bob Funk <bobfunk11@gmail.com>
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: Re: Bug Report - Kernel Branch 4.4.y - asus-wmi.c
Message-ID: <20191123061446.GA14713@1wt.eu>
References: <33bfa93a-3853-85f5-47f9-8a69ed9c656e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33bfa93a-3853-85f5-47f9-8a69ed9c656e@gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Nov 22, 2019 at 08:33:46PM -0600, Bob Funk wrote:
> Hello,
> 
> I am contacting the stable branch maintainers with a bug report concerning
> the asus-wmi kernel driver in the 4.4 kernel branch. I had initially
> contacted
> maintainers for the specific driver and received a response stating that I
> should contact the stable branch maintainers about the issue instead. Their
> opinion was that the patch in question should be reverted rather than
> debugged. I will append my initial report here and let you decide what to do
> with the bug.
> 
> 
> Original Bug Report:
> 
> The 2019-01-26 commit to the asus-wmi.c driver code in the 4.4 kernel
> branch has introduced a bug with several known models of EeePC netbooks.
> 
> Description of Problem:
> The bug occurs during boot, where the screen (possibly backlight?) will
> shut off and display hotkeys are unable to bring it back on. The problem
> is present on all kernels since the 2019-01-26 commit. There have been
> several reports of the issue in the slackware forum at linuxquestions.org
> 
> Corrective actions taken so far:
> Appending acpi_osi=Linux will circumvent the issue and keep the screen
> on, but this causes several error messages
> in the boot log about eeepc_wmi "failing to load both WMI and and legacy
> ATKD devices", and warns not to use acpi_osi=Linux.
> 
> Appending acpi_backlight=vendor also prevents the screen from shutting
> off during boot. However, pressing the brightness hotkeys
> causes the system to hang.
> 
> Reversing the asus-wmi.c patch that was committed on 2019-01-26 and
> rebuilding the 4.4 series module also fixes the problem, and brightness
> hotkeys work normally. The commit in question is
> 0c4a25cc6f2934f3aa99a0bbfd20b71949bcad25
> 
> Model I have tested this on: ASUS EeePC 1000H (Slackware 14.2, kernels
> 4.4.201, 4.4.202)
> Additional models reporting this issue: ASUS Eee PC 1005HAB, ASUS Eee PC
> 1225b, ASUS Eee PC 1025c (Slackware 14.2, various kernels from 4.4.172
> and higher)
> 
> Additional Notes:
> This problem seems to have been corrected in the 4.19 kernel branch, as
> reported by several users in the slackware forum.
> I attempted to test some of the fixes from the 4.19 code as patches to
> the 4.4 code but had no success. There have been multiple
> changes in that branch and I am unsure what exactly has corrected the
> bug in that version.
> 
> If there is any additional information that I can provide, please let me
> know.

I suspect that this is caused by missing commit 401fee81, which fixes
78f3ac76d9e5, was backported to 4.19 but not to 4.4. However you will
have to backport it by hand as it doesn't apply due to context
differences, but it trivial to do.

I am also running updated kernels on a 1025C and do not experience such
issues (5.4-rc8 now, but I used to run 4.4 till 4.4.79, which didn't
contain the backport of 78f3ac76d9e5).

Regards,
Willy
