Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F79529EF0D
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 16:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgJ2PDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 11:03:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60767 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727831AbgJ2PDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 11:03:17 -0400
Received: from 3.general.kamal.us.vpn ([10.172.68.53] helo=ascalon)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kamal@canonical.com>)
        id 1kY9SK-0007ad-Di; Thu, 29 Oct 2020 15:03:12 +0000
Received: from kamal by ascalon with local (Exim 4.90_1)
        (envelope-from <kamal@ascalon>)
        id 1kY9SG-00080X-Ec; Thu, 29 Oct 2020 08:03:08 -0700
From:   Kamal Mostafa <kamal@canonical.com>
To:     Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        stable <stable@vger.kernel.org>
Subject: v4.4.y broken by "Fix race while processing OPAL dump"
Date:   Thu, 29 Oct 2020 08:02:59 -0700
Message-Id: <20201029150259.30375-1-kamal@canonical.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi-

This commit from v4.4.241 breaks the v4.4.y build for powerpc:

217f139551c0 powerpc/powernv/dump: Fix race while processing OPAL dump

Like this:

.../arch/powerpc/platforms/powernv/opal-dump.c:409:7: error: void value not ignored as it ought to be
  dump = create_dump_obj(dump_id, dump_size, dump_type);
       ^


The commit descriptions says:

"... the return value of create_dump_obj() function isn't being used today ..."

But that's only true for kernels >= v4.19, because they carry this commit:

b29336c0e178 powerpc/powernv/opal-dump : Use IRQ_HANDLED instead of numbers in interrupt handler

In v4.4 process_dump(), the only caller of create_dump_obj(), still tries to
use the return value (see the error above).


Applying "b29336c0e178 powerpc/powernv/opal-dump : Use IRQ_HANDLED ..." to
v4.4.y fixes the problem.

 -Kamal

