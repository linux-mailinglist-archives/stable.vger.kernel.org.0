Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB1869D478
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 21:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjBTUKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 15:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbjBTUKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 15:10:51 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C07C1F4A3;
        Mon, 20 Feb 2023 12:10:50 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3918B20A6F;
        Mon, 20 Feb 2023 20:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1676923849;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JqaUUw9h6yGn+RO9miYtZiSL74aiYuIyVrj6o8I0aKE=;
        b=vB9hWS6LiCA45pFyOjNrd9ScsXuqDmD0hqbHDywYDt15MMsIniHhu1hv8lHy9aKpcq0EQ5
        cZ7oXa88Vvva+dRDXLxrxLW9xaiggMwgsOPvm91ukwFeswxArw1tESwoUmrHhOznD+Wf2R
        WYDhqh3eanMKlv8M41Stb4IY2ly4LCo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1676923849;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JqaUUw9h6yGn+RO9miYtZiSL74aiYuIyVrj6o8I0aKE=;
        b=suJf0sp81SHxEpqsh6WLM2WnBXhKbIF5ctT1zheHKJ1Q/o70WLfPHIeiZpQjcLb1qYqurs
        pB4AFkuw2syzZyAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 17AA4139DB;
        Mon, 20 Feb 2023 20:10:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NCHGBMnT82PiVgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 20 Feb 2023 20:10:49 +0000
Date:   Mon, 20 Feb 2023 21:04:53 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix unnecessary increment of read error stat on
 write error
Message-ID: <20230220200453.GF10580@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <29145a990313cb8759b8131b07f29694cc183ab3.1676265001.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29145a990313cb8759b8131b07f29694cc183ab3.1676265001.git.naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 13, 2023 at 02:10:38PM +0900, Naohiro Aota wrote:
> Current btrfs_log_dev_io_error() increases the read error count even if the
> erroneous IO is a WRITE request. This is because it forget to use "else
> if", and all the error WRITE requests counts as READ error as there is (of
> course) no REQ_RAHEAD bit set.
> 
> Fixes: c3a62baf21ad ("btrfs: use chained bios when cloning")
> CC: stable@vger.kernel.org # 6.1
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Added to misc-next, thanks.
