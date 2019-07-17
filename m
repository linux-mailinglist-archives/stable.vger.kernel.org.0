Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A716C385
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 01:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbfGQX21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 19:28:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbfGQX21 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 19:28:27 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BE0E20651;
        Wed, 17 Jul 2019 23:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563406106;
        bh=XmsYxaOve1geyvleo6Jf4RHapNuLhU3o0z+DTEAqN/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0+aodWGqRRSLoLaDtpsvdNUeHSj9KS8vQeLmSW68Y2ymk9YNLun26huKWyH3Uvibn
         HaGPtplctQEiNB2b0EMx54fxPFmdOxcOZXsgGydsgOdwiPcVScNvLdtRrQyyCzRAO9
         O22z3ylC6Na+zQSsksMPbJm5Vzju78NPuSg2xjJs=
Date:   Wed, 17 Jul 2019 19:28:25 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     Ross Zwisler <zwisler@chromium.org>, stable@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>,
        Guenter Roeck <groeck@google.com>
Subject: Re: [v4.14.y PATCH 0/2] fix drm/udl use-after-free error
Message-ID: <20190717232825.GA3079@sasha-vm>
References: <20190715193618.24578-1-zwisler@google.com>
 <20190716011308.GA1943@sasha-vm>
 <20190716160828.GA13008@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190716160828.GA13008@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 16, 2019 at 10:08:28AM -0600, Ross Zwisler wrote:
>On Mon, Jul 15, 2019 at 09:13:08PM -0400, Sasha Levin wrote:
>> On Mon, Jul 15, 2019 at 01:36:16PM -0600, Ross Zwisler wrote:
>> > This patch is the second in this series, and requires the first patch as
>> > a dependency.  This series apples cleanly to v4.14.133.
>>
>> Hm, we don't need ac3b35f11a06 here? Why not? I'd love to document that
>> with the backport.
>
>Nope, we don't need that patch in the v4.14 backport.
>
>In v4.19.y we have two functions, drm_dev_put() and drm_dev_unref(), which are
>aliases for one another (drm_dev_unref() just calls drm_dev_put()).
>drm_dev_unref() is the older of the two, and was introduced back in v4.0.
>drm_dev_put() was introduced in v4.15 with
>
>9a96f55034e41 drm: introduce drm_dev_{get/put} functions
>
>and slowly callers were moved from the old name (_unref) to the new name
>(_put).  The patch you mentioned, ac3b35f11a06, is one such patch where we are
>replacing a drm_dev_unref() call with a drm_dev_put() call.  This doesn't have
>a functional change, but was necessary so that the third patch in the v4.19.y
>series I sent would apply cleanly.
>
>For the v4.14.y series, though, the drm_dev_put() function hasn't yet been
>defined and everyone is still using drm_dev_unref().  So, we don't need a
>backport of ac3b35f11a06, and I also had a small backport change in the last
>patch of the v4.14.y series where I had to change a drm_dev_put() call with a
>drm_dev_unref() call.
>
>Just for posterity, the drm_dev_unref() calls were eventually all changed to
>drm_dev_put() in v5.0, and drm_dev_unref() was removed entirely.  That
>happened with the following two patches:
>
>808bad32ea423 drm: replace "drm_dev_unref" function with "drm_dev_put"
>ba1d345401476 drm: remove deprecated "drm_dev_unref" function

Thank you for the explanation. I've queued both this and the 4.19
patches, and added your explanation to the 4.14 patch.

--
Thanks,
Sasha
