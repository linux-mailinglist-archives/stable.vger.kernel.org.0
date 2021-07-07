Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5923BE6D8
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 13:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhGGLHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 07:07:03 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:41888 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbhGGLHD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 07:07:03 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5F50020061;
        Wed,  7 Jul 2021 11:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625655862; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A8ClwgW0RVTnenCLynxkGUFKeKqBcUyTdIUA4Lh1zWI=;
        b=emrqRBBccGASSW+yQRN8sw/eF/KL7j9dOoMCaLLDvdZJcWi65Z/gDOG9LEpHt0KHUphrro
        KHgZo/HOxkDWHem2OTVStMywJ72dtajCEVHew7PwMv9oU+pPxMHb1jUxXe+1KYTlvQGI5H
        poWC6RC2/4XPO3DM/5dfpblvFdRknUc=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 12A6413998;
        Wed,  7 Jul 2021 11:04:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id Ss+nATaK5WAvXwAAGKfGzw
        (envelope-from <nborisov@suse.com>); Wed, 07 Jul 2021 11:04:22 +0000
Subject: Re: [PATCH v2 4/8] btrfs: wake up async_delalloc_pages waiters after
 submit
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, linux-fsdevel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <cover.1624974951.git.josef@toxicpanda.com>
 <54425f6e0ece01f5d579e1bcc0aab22a988c301f.1624974951.git.josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
Message-ID: <ce2a44cb-df97-a5fb-de16-afd8360a06f0@suse.com>
Date:   Wed, 7 Jul 2021 14:04:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <54425f6e0ece01f5d579e1bcc0aab22a988c301f.1624974951.git.josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 29.06.21 г. 16:59, Josef Bacik wrote:
> We use the async_delalloc_pages mechanism to make sure that we've
> completed our async work before trying to continue our delalloc
> flushing.  The reason for this is we need to see any ordered extents
> that were created by our delalloc flushing.  However we're waking up
> before we do the submit work, which is before we create the ordered
> extents.  This is a pretty wide race window where we could potentially
> think there are no ordered extents and thus exit shrink_delalloc
> prematurely.  Fix this by waking us up after we've done the work to
> create ordered extents.
> 
> cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

This is an independent change from the rest of the series and it can go
before the rest.
