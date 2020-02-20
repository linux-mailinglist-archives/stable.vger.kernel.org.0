Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5636B1661F1
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 17:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgBTQLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 11:11:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:60836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbgBTQLm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 11:11:42 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 231F820659;
        Thu, 20 Feb 2020 16:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582215101;
        bh=OHPpGTXwOBTQ+2n7AONE/bLL7UPY/3XpZR9aEfGY5xM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tUpBRmCOj/opRcbrtI1aId22Ku/rmQkrAvKDjrHQ9UQnEOF9zU5nQveqius779w6P
         3WK8hA9fioJujhP9U61mzeSVz9jctGiGohQnifWGjyldb4iPU+dc55b3nqVFGq8vJ2
         FXfehNGI2V6JI/1SfZTFo8ZC/gNCOTUVi4swLx8s=
Date:   Thu, 20 Feb 2020 11:11:39 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 094/542] s390/pci: Fix possible deadlock in
 recover_store()
Message-ID: <20200220161139.GB1734@sasha-vm>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-94-sashal@kernel.org>
 <20200217093156.GB42010@tuxmaker.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200217093156.GB42010@tuxmaker.boeblingen.de.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 10:31:56AM +0100, Niklas Schnelle wrote:
>On Fri, Feb 14, 2020 at 10:41:26AM -0500, Sasha Levin wrote:
>> From: Niklas Schnelle <schnelle@linux.ibm.com>
>>
>> [ Upstream commit 576c75e36c689bec6a940e807bae27291ab0c0de ]
>>
>> With zpci_disable() working, lockdep detected a potential deadlock
>> (lockdep output at the end).
>>
>> The deadlock is between recovering a PCI function via the
>>
>> /sys/bus/pci/devices/<dev>/recover
>>
>> attribute vs powering it off via
>>
>> /sys/bus/pci/slots/<slot>/power.
>>
>> The fix is analogous to the changes in commit 0ee223b2e1f6 ("scsi: core:
>> Avoid that SCSI device removal through sysfs triggers a deadlock")
>> that fixed a potential deadlock on removing a SCSI device via sysfs.
>[ ... snip ... ]
>
>While technically useful on its own this commit really should go together with
>the following upstream commit:
>
>17cdec960cf776b20b1fb08c622221babe591d51
>("s390/pci: Recover handle in clp_set_pci_fn()")
>
>While the problem fixed here is independent,  writing to the power/recover
>attributes will often fail due to an inconsistent function handle without the
>second commit.
>In particular without it a PCI function in the error state can not be
>recovered or powered off.
>
>I would recommend adding the second commit to the backports as well.

I took that commit as well, thank you.

-- 
Thanks,
Sasha
