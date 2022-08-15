Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1FEA592DE9
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 13:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbiHOLKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 07:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiHOLKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 07:10:12 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E48A46B
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 04:10:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3DE563512D;
        Mon, 15 Aug 2022 11:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660561809;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type;
        bh=gcX0J11PtGaSQUmxYCxIQYDnVMTa0E4BN2F1aCntmgA=;
        b=JbWmfXxuMdWxnVP8wsF2zA0/VIuMWOZgdAVcPKurhMUH/NZTuHX92Osmv/I173tzyBFxj1
        oEJaI9Y5fXoO5piXmyAWOHObwXDmwG4bWr3EZ2ikMi+oFlvhdZFs+aLhBBtW/y5mmOWNBQ
        pvzVq3ZIq00YpWaWNMSNcDwUWZhxk80=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660561809;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type;
        bh=gcX0J11PtGaSQUmxYCxIQYDnVMTa0E4BN2F1aCntmgA=;
        b=LBXZGjmjmsSrLYkzbNFvYUhGlv3xHYNoZxh2t63ryaqb6uspF2JH/rfaIMN+UismGdTRv+
        C+/DDhuIcfI8KrDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E21EB13A93;
        Mon, 15 Aug 2022 11:10:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jeiPNZAp+mKeCQAAMHmgww
        (envelope-from <pvorel@suse.cz>); Mon, 15 Aug 2022 11:10:08 +0000
Date:   Mon, 15 Aug 2022 13:10:07 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     stable@vger.kernel.org, linux-mm@kvack.org
Cc:     Michal Hocko <mhocko@kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        William Roche <william.roche@oracle.com>, ltp@lists.linux.it
Subject: Backport d4ae9916ea29 ("mm: soft-offline: close the race against
 page allocation") to 4.14 and 4.9
Message-ID: <Yvopj0gK5Dg95u+b@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

I wonder if there was an attempt to backport d4ae9916ea29 ("mm: soft-offline:
close the race against page allocation") from 4.19 to 4.14 and 4.9 (patch does
not apply, haven't found anything on stable ML, nor in stable tree git,
therefore I assume it was left as not easily fixable).

I'm asking because William is writing a LTP test madvise11 [1] which shows it's
failing on 4.14.290 (the latest 4.14). I know that 4.9 EOL in 4 months, but 4.14
in Jan 2024, it might be worth to fix it at least for 4.14.

Kind regards,
Petr

[1] https://lore.kernel.org/ltp/1659975072-29808-1-git-send-email-william.roche@oracle.com/
