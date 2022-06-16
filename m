Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6817F54E27E
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 15:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376931AbiFPNv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 09:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377275AbiFPNv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 09:51:56 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A659B41608;
        Thu, 16 Jun 2022 06:51:54 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 1CED5C01D; Thu, 16 Jun 2022 15:51:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655387513; bh=2Hb1WIC7htcZUnTVocd9sTq0i8DWUd+UIspEOkNnz10=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rdxn534uKTaSDTnJiKZKi3gw63uExrASQ8SFeMr3Ze1hbArPYP1vZ4blzabc8AMAA
         tRTYSmBpprD6zoelusqs7oaZOgz8lZxCCmEPCSeh8nw109GGqJjdPFP8MV7ieaslqq
         JRO90MUCrLC2rGp3Cv2VCAgZt0mOYsNk5nDBgmu+y/SWxFNyVLRpoypJz/NS71r/S3
         mFQWkcluCHS0ml4fH0tpAbVHkTZvpIyXRtsxdV2B4VSGPbKf5K9NGCgsJ0KtkNZPgN
         iKjIitmiBo1KOxxv7lmA/O6fk0ZCseUFiLa0Tqh0sT8Zc7D0pPrfl8T0S9XYeXltUH
         HQad/TpMqM7WA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 319D6C009;
        Thu, 16 Jun 2022 15:51:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655387512; bh=2Hb1WIC7htcZUnTVocd9sTq0i8DWUd+UIspEOkNnz10=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QTlFwM8XKRVvm2Y//7ChStOXQIIwD2Lu4eHvWvT2h0qHXFRtDtdO1mT0YWLnSyG6X
         nYBJiK36PBA9rueqp54TNCCcrmJzMC4GMxd0km7GjC3PuSd1Y+/vvfTGBpSjtIvY1w
         XcprBK83g+J5v1zhy32WW0zgbl0TyxGpZF7uvVDkYsz33vcbYKCz5N/BKodb5eKryM
         0nM/nilLra97HaoleGvFSO77l8v/5n96g0BDhPA5TjLwjIblOO3u1rmzjSvBt06t5c
         IqKmEZySzErOC20CfAPn7X3N7ApmdVnIgR3qFJs5AKe3++/Dzh/HzTTeoDFqHemJlH
         N0JIVIUu35rIw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id c6d6cc5f;
        Thu, 16 Jun 2022 13:51:46 +0000 (UTC)
Date:   Thu, 16 Jun 2022 22:51:31 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix EBADF errors in cached mode
Message-ID: <Yqs1Y8G/Emi/q+S2@codewreck.org>
References: <YqW5s+GQZwZ/DP5q@codewreck.org>
 <YqiC8luskkxUftQl@codewreck.org>
 <1796737.mFSqR1lx0c@silver>
 <22073313.PYDa2UxuuP@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <22073313.PYDa2UxuuP@silver>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Christian Schoenebeck wrote on Thu, Jun 16, 2022 at 03:35:59PM +0200:
> 2. I fixed the conflict and gave your patch a test spin, and it triggers
> the BUG_ON(!fid); that you added with that patch. Backtrace based on
> 30306f6194ca ("Merge tag 'hardening-v5.19-rc3' ..."):

hm, that's probably the version I sent without the fallback to
private_data fid if writeback fid was sent (I've only commented without
sending a v2)

> 1. your EBADF patch is based on you recent get/put refactoring patch, so it won't apply on stable.

ugh, you are correct, that was wrong as well in the version I sent by
mail... I've hurried that way too much.

The patch that's currently on the tip of my 9p-next branch should be
alright though, I'll resend it now so you can apply cleanly if you don't
want to fetch https://github.com/martinetd/linux/commits/9p-next

> Did your patch work there for you? I mean I have not applied the other pending
> 9p patches, but they should not really make difference, right? I won't have
> time today, but I will continue to look at it tomorrow. If you already had
> some thoughts on this, that would be great of course.

Yes, my version passes basic tests at least, and I could no longer
reproduce the problem.

Without the if (!fid) fid = file->private_data though it does fail
horribly like you've found out.

--
Dominique
