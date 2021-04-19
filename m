Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215F03645EF
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 16:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238543AbhDSOXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 10:23:07 -0400
Received: from mx.cjr.nz ([51.158.111.142]:21464 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239334AbhDSOXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 10:23:07 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 707257FC03;
        Mon, 19 Apr 2021 14:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1618841713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PHvsKY71Twx7y7UKiMO8xtu/3Zh3WQE49bco6gIlXEw=;
        b=TpYwamFB2LDHR2sa46jTRPZAYf0xMJB0ujuaSTgKUMrjOT34Sne7uJlpKFaosEahilXyNd
        PGby9LOqv7u4piN/rOakxIwlLW8AUgUP0nPY/KOvKmMLIpME7K97ZOgMpfQ3kztR/aq0qw
        RmLGSmzCRRDe76ARUjRv9LqOOPsF4P9Aso39tL82Trp99bEvN9zm6TvnAwh/v3csmGqPiV
        083Tg2kRkJFr56iiyHScEgA/l7AfqRtxNOzaR+3JhuvkO6dzemE4ajm3N3yfStQAQNSwB7
        yOOTeWkVG71EJeEtzM3CXyNcyDjWDwP5FlkRNeqyzy+HsDCPaBaioT0SYVrqqQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Salvatore Bonaccorso <carnil@debian.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Shyam Prasad <Shyam.Prasad@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
In-Reply-To: <YHwo5prs4MbXEzER@eldamar.lan>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161032.337414143@linuxfoundation.org>
 <YGxIMCsclG4E1/ck@eldamar.lan> <YGxlJXv/+IPaErUr@kroah.com>
 <PSAP153MB04220682838AC9D025414B6094769@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YGx3u01Wa/DDnjlV@eldamar.lan> <YG7r0UaivWZL762N@eldamar.lan>
 <YHP+XbVWfGv21EL1@kroah.com> <YHwo5prs4MbXEzER@eldamar.lan>
Date:   Mon, 19 Apr 2021 11:15:15 -0300
Message-ID: <878s5e9x8s.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Salvatore Bonaccorso <carnil@debian.org> writes:

> Thanks Greg! Shyam, Steven, now the commit was reverted for the older
> brnaches. But did you got a chance to find why it breaks for the older
> series?

That commit has revealed another bug in cifs_mount() where we failed to
update the super's prefix path after chasing DFS referrals.

Newer kernel versions do not have it because the code & logic in
cifs_mount() changed entirely.
