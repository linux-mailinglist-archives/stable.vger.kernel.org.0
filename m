Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2A99F880
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 05:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfH1DCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 23:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbfH1DCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 23:02:19 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDCF220674;
        Wed, 28 Aug 2019 03:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566961338;
        bh=RDSQqkdwT/l2dfY6CLVb889H2LImUnadgP6hEdEu8kE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g0zYB32t/lQXi6CregD22CqJ/Mb+M1oS/T+M8msGz/4x41i8VV3mskjZ7877x91d5
         x6rDmB4P2ZmUT3WmVp2Fb2wK8g1pjTEFGzdNkKsOT6S+1HBgV8cgN8UehVOovSJReJ
         ugd1EEp8nuqJ2z0eADAglzMhQiR65Musmn89nOOw=
Date:   Tue, 27 Aug 2019 23:02:16 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Richter <tmricht@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 4.9 033/223] perf test 6: Fix missing kvm module load for
 s390
Message-ID: <20190828030216.GX5281@sasha-vm>
References: <20190802092238.692035242@linuxfoundation.org>
 <20190802092241.125480296@linuxfoundation.org>
 <3c6356b7406c0a49b8262b9b4b7326afd367a3f5.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3c6356b7406c0a49b8262b9b4b7326afd367a3f5.camel@decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 01:12:44AM +0100, Ben Hutchings wrote:
>On Fri, 2019-08-02 at 11:34 +0200, Greg Kroah-Hartman wrote:
>> [ Upstream commit 53fe307dfd309e425b171f6272d64296a54f4dff ]
>
>This results in numerous compiler errors:
>
>tests/parse-events.c: In function 'kvm_s390_create_vm_valid':
>tests/parse-events.c:25:14: error: implicit declaration of function 'get_events_file' [-Werror=implicit-function-declaration]
>  eventfile = get_events_file("kvm-s390");
>              ^~~~~~~~~~~~~~~
>tests/parse-events.c:25:12: error: assignment makes pointer from integer without a cast [-Werror=int-conversion]
>  eventfile = get_events_file("kvm-s390");
>            ^
>tests/parse-events.c:34:3: error: implicit declaration of function 'put_events_file' [-Werror=implicit-function-declaration]
>   put_events_file(eventfile);
>   ^~~~~~~~~~~~~~~
>tests/parse-events.c: At top level:
>tests/parse-events.c:1622:3: error: unknown field 'valid' specified in initializer
>   .valid = kvm_s390_create_vm_valid,
>   ^
>tests/parse-events.c:1622:12: error: excess elements in struct initializer [-Werror]
>   .valid = kvm_s390_create_vm_valid,
>            ^~~~~~~~~~~~~~~~~~~~~~~~
>tests/parse-events.c:1622:12: note: (near initialization for 'test__events[45]')
>
>It is using functions that were only added in Linux 4.18 so I think it
>should be reverted from the 4.4, 4.9, and 4.14 stable branches.

Sigh... I didn't think of adding cross compilation to the tools dir...

Thanks for this, now reverted for those branches.

--
Thanks,
Sasha
