Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FAF6E3C28
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 23:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjDPVau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 17:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDPVat (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 17:30:49 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D261D1FEB;
        Sun, 16 Apr 2023 14:30:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8BB8721A37;
        Sun, 16 Apr 2023 21:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681680646; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SFzJ92Ds6qpIDo63JHIGufVFHdpCoBu1yLuu/vLCv/E=;
        b=pGl/KhniKaKPA2AmoBurACAVaaEw0wJKpHXCEvx09/+Et5bamkJV5N9nzWbz8u3E/+IpfV
        htRQpqyBzljMiHS7B0u8fq+Ez/kmqH5C4vcpQ9hvAhzKmEA6pFdq5Lo7n3LoGkDwadFGqD
        zJFEZXHJDEjy7vsHxFBK0ZmaGzugQw4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681680646;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SFzJ92Ds6qpIDo63JHIGufVFHdpCoBu1yLuu/vLCv/E=;
        b=BDeaN3KXAI1ePtF+toCwdJGEMbVvQYhwhpwCgyArKB5oi5/ucjo30JSNFNMsgSB/xvvVjY
        W0uTTSzU7vqwpzAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0AA59139CC;
        Sun, 16 Apr 2023 21:30:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bYeUKwNpPGReWgAAMHmgww
        (envelope-from <neilb@suse.de>); Sun, 16 Apr 2023 21:30:43 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Sylvain Menu" <sylvain.menu@gmail.com>
Cc:     "Greg KH" <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        regressions@lists.linux.dev, chuck.lever@oracle.com,
        jlayton@kernel.org, linux-nfs@vger.kernel.org
Subject: Re: nfs mount disappears due to inode revalidate failure
In-reply-to: <CACH9xG_v_2Y9d3Q16YB57Q5xVwSXe5FqLFSnjox6GotOT3DPmw@mail.gmail.com>
References: <CACH9xG8-tEtWstUVmD9eZFEEAqx-E8Gs14wDL+=uNtBK=-KJvQ@mail.gmail.com>,
 <ZAmv57xeNqs7v9hY@kroah.com>,
 <CACH9xG9=BFszD9OXspttTFdki0e68b5Hw7o11AUQ7pptSMy9wQ@mail.gmail.com>,
 <ZAmzT/D8YxJ3844j@kroah.com>,
 <CACH9xG_v_2Y9d3Q16YB57Q5xVwSXe5FqLFSnjox6GotOT3DPmw@mail.gmail.com>
Date:   Mon, 17 Apr 2023 07:30:40 +1000
Message-id: <168168064006.24821.8358959637978538396@noble.neil.brown.name>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Mar 2023, Sylvain Menu wrote:
> No I don't have that, I found the bug in production by no chance.
> I tried to dive into the code but it quickly becomes complex for me,
> at least it's easy to reproduce with a little script (while(1) timeout
> my_c.code)
>=20
> thanks
> sylvain menu
>=20
> Le jeu. 9 mars 2023 =C3=A0 11:22, Greg KH <gregkh@linuxfoundation.org> a =
=C3=A9crit :
> >
> > On Thu, Mar 09, 2023 at 11:17:30AM +0100, Sylvain Menu wrote:
> > > I think it's a regression according to the old resolved bugs/tickets
> > > but no idea since when it's broken again
> >
> > Any chance you can do 'git bisect' to find where it broke and what
> > commit broke it?

Please see
   https://lore.kernel.org/linux-nfs/87361aovm3.fsf@notabene.neil.brown.name/

I posted a patch for this a couple of years ago, but Trond wouldn't take
it.

NeilBrown


> >
> > thanks,
> >
> > greg k-h
>=20

