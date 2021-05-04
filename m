Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1073A372E3C
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 18:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhEDQsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 12:48:55 -0400
Received: from mx.cjr.nz ([51.158.111.142]:37122 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230133AbhEDQsz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 12:48:55 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 3D4417FCE4;
        Tue,  4 May 2021 16:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1620146879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LFn8AbBDaL59wgE+SLUcpIxK82fO/PvTvuyxFR/r4BA=;
        b=sw/R1oAmNNqRLMAB9MgMvR30vR/NWaqIvCr6a6DLkC9ew43G4B5es6rePOIDxiNGF/CsX5
        c6rjRG6RV5vpu/lvpf8SU5oRu73n2tZmlXO7KCHkn4jVyK/usfBV/DcIa1Tz2ps0vjJNFg
        4wxi/cgP022BLX7hIz87pkeyajlKbRvM3Y/XNh9TzwsUx/jBUcq/UMy/c1q0bLw93cEess
        RDOPu78ilg2g5TqG+39XDWsuOpfFeSBZOO330xQphyjC3gKl9eNJ80ehJBuMTnfC3ybP1s
        7YxY1sANFObKNivBvWgrkpoZ2y2JtYmoPuTy9rx69DwTU3OlmFeB/yQld9VBCg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     David Disseldorp <ddiss@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, aaptel@suse.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] cifs: fix regression when mounting shares with
 prefix paths
In-Reply-To: <20210504012027.6deac39a@suse.de>
References: <20210430221621.7497-1-pc@cjr.nz>
 <20210503145526.9705-1-pc@cjr.nz> <20210504012027.6deac39a@suse.de>
Date:   Tue, 04 May 2021 13:47:52 -0300
Message-ID: <87y2cuigxz.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

David Disseldorp <ddiss@suse.de> writes:

> On Mon,  3 May 2021 11:55:26 -0300, Paulo Alcantara wrote:
>> -	rc = cifs_setup_volume_info(cifs_sb->ctx, NULL, old_ctx->UNC);
>> +	rc = cifs_setup_volume_info(cifs_sb->ctx, NULL, NULL);
>
> IIUC, with the new behaviour, this call becomes pretty much an
> 	if (!cifs_sb->ctx->username)
> 		root = ERR_PTR(-EINVAL);

Yeah.  We should get rid of the damn thing at some point.  I've just
tried to keep the logic we currently have in fs/cifs/connect.c by
composing new options based upon the chased DFS referrals.

Thanks for pointing it out!
