Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325BD2C3D39
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 11:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgKYKHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 05:07:33 -0500
Received: from mail.thorsis.com ([92.198.35.195]:42974 "EHLO mail.thorsis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbgKYKHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 05:07:33 -0500
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2020 05:07:33 EST
Received: from localhost (localhost [127.0.0.1])
        by mail.thorsis.com (Postfix) with ESMTP id 2EBC235DD
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 11:01:47 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at mail.thorsis.com
Received: from mail.thorsis.com ([127.0.0.1])
        by localhost (mail.thorsis.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pdj3FgB0BQUA for <stable@vger.kernel.org>;
        Wed, 25 Nov 2020 11:01:43 +0100 (CET)
Received: by mail.thorsis.com (Postfix, from userid 109)
        id EB0203606; Wed, 25 Nov 2020 11:01:42 +0100 (CET)
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=ham autolearn_force=no version=3.4.2
From:   Alexander Dahl <ada@thorsis.com>
To:     stable@vger.kernel.org
Subject: perf: Apply e9a6882f267a to v4.9 stable (fix for null-pointer dereference)
Date:   Wed, 25 Nov 2020 11:01:39 +0100
Message-ID: <4431770.U1WXKbcAmY@ada>
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hei hei,

please apply e9a6882f267a8105461066e3ea6b4b6b9be1b807 ("perf event: Check 
ref_reloc_sym before using it") to the v4.9 stable tree and maybe to later LTS 
trees (v4.14, v4.19) as well. 

That change is in mainline since v5.4-rc1 and it's a fix for a possible null 
pointer dereference in the tool 'perf', so it is a fix for a user space tool 
coming with the kernel tree actually.

I am directly affeted by this, calling 'perf record' on an at91 based device 
(armv5te, sam9g20 soc) running PREEMPT RT kernel 4.9.220-rt143 results in a 
segfault here.  I debugged this with gdb and tracked it down to the exact 
pointer being NULL, which is checked now in that above mentioned changeset.

I could cleanly apply that changeset to my local tree and the segfault is not 
triggered anymore, I can use perf on that platform now.

I only tested this on the above mentioned v4.9 based kernel version.

Thanks & Greets
Alex



