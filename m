Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F1730FE44
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 21:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240125AbhBDU2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 15:28:24 -0500
Received: from manchmal.in-ulm.de ([217.10.9.201]:59194 "EHLO
        manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240103AbhBDU2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 15:28:13 -0500
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Feb 2021 15:28:11 EST
Date:   Thu, 4 Feb 2021 21:19:33 +0100
From:   Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Kernel version numbers after 4.9.255 and 4.4.255
Message-ID: <1612468714@msgid.manchmal.in-ulm.de>
References: <7pR0YCctzN9phpuEChlL7_SS6auHOM80bZBcGBTZPuMkc6XjKw7HUXf9vZUPi-IaV2gTtsRVXgywQbja8xpzjGRDGWJsVYSGQN5sNuX1yaQ=@protonmail.com>
 <YBuSJqIG+AeqDuMl@kroah.com>
 <78ada91b-21ee-563f-9f75-3cbaeffafad4@kernel.org>
 <YBu1d0+nfbWGfMtj@kroah.com>
 <a85b7749-38b2-8ce9-c15a-8acb9a54c5b5@kernel.org>
 <b17b4c3b2e4b45f9b10206b276b7d831@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b17b4c3b2e4b45f9b10206b276b7d831@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

David Laight wrote...

> A full wrap might catch checks for less than (say) 4.4.2 which
> might be present to avoid very early versions.
> So sticking at 255 or wrapping onto (say) 128 to 255 might be better.

Hitting such version checks still might happen, though.

Also, any wrapping introduces a real risk package managers will see
version numbers running backwards and therefore will refrain from
installing an actually newer version.

For scripts/package/builddeb (I don't use that, though), you could work
around by setting an epoch, i.e. (untested)

-$sourcename ($packageversion) $distribution; urgency=low
+$sourcename (1:$packageversion) $distribution; urgency=low

but every packaging mechanism in-tree and outside should adopt such a
change, if even possible. Which is why this feels bad.

Possibly I am missing something: What's the reason to not use
EXTRAVERSION as back in the old 2.6.x.y days, so change to 4.4.255.1 and
so on? Well, unless there are still installations who treat 4.4.255 as
2.6.64.255.

    Christoph
