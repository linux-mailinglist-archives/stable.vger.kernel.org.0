Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2AA544E2A
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 15:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245141AbiFINzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 09:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244880AbiFINzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 09:55:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFFA51307;
        Thu,  9 Jun 2022 06:55:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0F9D21FD8A;
        Thu,  9 Jun 2022 13:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654782903; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=91neXvjDA4WUlBHdjw+HMGhnqYjTNuLcq5bXiJvB4Nc=;
        b=Wx7SbIPJveRgf/aUxiDkc2ndUaYrgRcFkhXSOFfYiVhCP+5tA/YIYk/FQbKXw6OcZ7NDWd
        xPANBma5VJ5UEizNfSS8cXM4gxx9ZF9A8A8j1qi9oEkVG0lXmlOcKNouWGTDednypYK6kz
        3KNNiCIZMmcAlY9PYTFCHDP4GASSop8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654782903;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=91neXvjDA4WUlBHdjw+HMGhnqYjTNuLcq5bXiJvB4Nc=;
        b=e3QjTfOV581oDVyaadsp3TS2BuaX0bCJhKE4mtl5jFVb61sjHi08pEH88FP4tcJ0YVQxLd
        8Rb1UynSgiM6JJAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4367113456;
        Thu,  9 Jun 2022 13:54:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VdZdOrP7oWIpYwAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 09 Jun 2022 13:54:59 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 4/4] bcache: avoid journal no-space deadlock by reserving
 1 journal bucket
From:   Coly Li <colyli@suse.de>
In-Reply-To: <8735geanp8.fsf@esperi.org.uk>
Date:   Thu, 9 Jun 2022 21:54:55 +0800
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Nikhil Kshirsagar <nkshirsagar@gmail.com>,
        stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2FDA62C4-AFB2-4215-AD71-2EC6E14A4F5D@suse.de>
References: <20220521170502.20026-1-colyli@suse.de>
 <20220521170502.20026-4-colyli@suse.de> <8735geanp8.fsf@esperi.org.uk>
To:     Nix <nix@esperi.org.uk>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> 2022=E5=B9=B46=E6=9C=889=E6=97=A5 04:45=EF=BC=8CNix =
<nix@esperi.org.uk> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 21 May 2022, Coly Li spake thusly:
>=20
>> When all journal buckets are fully filled by active jset with heavy
>> write I/O load, the cache set registration (after a reboot) will load
>> all active jsets and inserting them into the btree again (which is
>> called journal replay). If a journaled bkey is inserted into a btree
>> node and results btree node split, new journal request might be
>> triggered. For example, the btree grows one more level after the node
>> split, then the root node record in cache device super block will be
>> upgrade by bch_journal_meta() from bch_btree_set_root(). But there is =
no
>> space in journal buckets, the journal replay has to wait for new =
journal
>> bucket to be reclaimed after at least one journal bucket replayed. =
This
>> is one example that how the journal no-space deadlock happens.
>>=20
>> The solution to avoid the deadlock is to reserve 1 journal bucket in
>=20
> It seems to me that this could happen more than once in a single =
journal
> replay (multiple nodes might be split, etc). Is one bucket actually
> always enough, or is it merely enough nearly all the time?

It is possible that multiple leaf nodes split during journal replay, but =
the journal_meta() only gets called when the root node is updated.
For the new bkey of the new split node inserting into root node, it =
doesn=E2=80=99t go into journal because journal only records inserting =
bkeys for leaf nodes. Only when the btree node split causes root node =
split, the new root node location (bkey) has to be recored in journal =
set.

Therefore almost all the time that btree root node only splits once =
during journal replay, it is very rare that between two root node splits =
(that means very large number of bkeys inserted) the oldest journal =
entry doesn=E2=80=99t get replayed, that is almost impossible in real =
practice. So reserving 8K journal space is indeed enough for the =
no-space deadlock situation.

The default bucket size is much larger than 8K, so we don=E2=80=99t have =
to worry about the reserved journal space exhausted even with a much =
larger journal buckets number.

Indeed my initial effort was to reserve 8K space within a journal bucket =
if the bucket size > 8KB. But there are too many locations should be =
careful, and the logic of the patch is complicated and total change set =
is 200+ lines. And I find if I reserve a whole bucket, the change set is =
only 30+ lines. So finally I decide to reserve a whole journal bucket, =
because the change is much simpler and easier to be understood.

Coly Li=
