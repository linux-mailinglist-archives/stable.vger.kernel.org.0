Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45A1F579C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731341AbfKHTa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:30:57 -0500
Received: from mailin.studentenwerk.mhn.de ([141.84.225.229]:34290 "EHLO
        email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729896AbfKHTa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 14:30:57 -0500
Received: from mailhub.studentenwerk.mhn.de (mailhub.studentenwerk.mhn.de [127.0.0.1])
        by email.studentenwerk.mhn.de (Postfix) with ESMTPS id 478r3L4jM5zRhSv;
        Fri,  8 Nov 2019 20:30:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de; s=stwm-20170627;
        t=1573241454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EFykoFq0fZCoJ9NEzLWdE9Ihbdj2brM+E0J3xLqActg=;
        b=c5TtgqgILe41UaVRiYHv1EMikPumcA00d5WLQWNQk3G72U3rRMMtq9ThGE2utKObCES+Qu
        7ZCckHthxwupd5om6ymWoh3sjjIyx6A1mfxrV0kDVXTKlvLAUc8Y6X8ER848L9bVafGjnK
        qMy5VCjE2l5+IYe6FnPwfU41YDrBd+2VqN625jl5cbrRZJd3EwXaiIx0ULTBDqg6xAa1Ex
        njFjjPnFECzojJA9O22sxgPQO2LeRsv1xxOd7lBbzVUwYDOZEBvg5oKIoxfVh/ctWAHsgn
        7SBlrm1wac9D3iJp4eWwBbRqlhJRnRGIi1R6H//RJSLVcsJIalhxKCcn/7osJA==
From:   Wolfgang Walter <linux@stwm.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     drbd-dev@lists.linbit.com, stable@vger.kernel.org
Subject: Re: stable 4.19.80 and 4.19.81: BAD! BarrierAck seen in drbd
Date:   Fri, 08 Nov 2019 20:30:54 +0100
Message-ID: <3722647.I7WfpmyJte@stwm.de>
User-Agent: KMail/4.14.3 (Linux/5.0.6-050006-generic; KDE/4.14.13; x86_64; ; )
In-Reply-To: <20191108174118.GA1212727@kroah.com>
References: <4418981.SUHPA3XYOi@stwm.de> <20191108174118.GA1212727@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de;
        s=stwm-20170627; t=1573241454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EFykoFq0fZCoJ9NEzLWdE9Ihbdj2brM+E0J3xLqActg=;
        b=kqwoFLzoULvLEtyQctBKrPahcBWb9dJVauEu+igux+LsS9ewNo3gwo0jszZKyrFM91siAt
        VLYCEYspn9ItkWK2LFP+k+ixCIDHFtK/7++ceZYXsCk3MQhaRzSOzh+TlrDbX26nUmYH4r
        SYMJt1mHZuAzxmV4kW/xi38jzmVUjbHr9wgcXgPgn/l7x8W7RNd6LMLM0quXDS9vzWEL1v
        PptvPF/TWF8tIAQ67kSHrmCokE0Eog+ooPdr6Kkx2gcPqib3bOSkT/nhKS27nrCrCcRzcI
        radkBbWaIlAoFlBjE3JesuWnIwqKftOU9wrJ+3GNVmrZeArOg2E0+lPEOGLrnw==
ARC-Seal: i=1; s=stwm-20170627; d=stwm.de; t=1573241454; a=rsa-sha256;
        cv=none;
        b=HsyIficFekoJqwh3iqUHbEGYJCBuIayO0+4W048tm6uh+/fLVFcesYAM0hhNmpa3Mt9/Na
        bywPJrs2adS2I5Sl+oNRRwoZjcH58UVE5osazrlz/qjg0crcf1SLaRvYabc+RBVt+dHMJ8
        xjrpaCfEBitJNn1AIaoVYTjvOfygXDAbtz3tBiQhGXzx4TkFCg8o4F4aORpfg8mwuKcZS7
        LphyP6er4gzTqrxYQcCBy6Ls0o7hWb6gCdlQJ0JRDuXh8B1s91Z8t1v3bTptnZZtWZwWcS
        i8mBZaTZnpMZgm/FEIihKGeyhboBuOjl4tnYyqueFElXHPDzE/+ydk8vT/Ovdg==
ARC-Authentication-Results: i=1;
        email.studentenwerk.mhn.de;
        none
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Freitag, 8. November 2019, 18:41:18 schrieb Greg KH:
> On Fri, Nov 08, 2019 at 05:38:13PM +0100, Wolfgang Walter wrote:
> > Hello,
> >=20
> > starting with 4.19.80 we saw twice this message from drbd (primary)=
:
> >=20
> > [335776.845165] drbd fastexport: BAD! BarrierAck #24834877 received=
,
> > expected #24834876! [335776.845272] drbd fastexport: peer( Secondar=
y ->
> > Unknown ) conn( Connected -> ProtocolError ) pdsk( UpToDate -> DUnk=
nown )
> > [335776.845359] drbd fastexport: ack_receiver terminated
> > [335776.845361] drbd fastexport: Terminating drbd_a_fastexpo
> > [335776.845452] block drbd131: new current UUID
> > E5F844267DB80A79:9823CD86802A0EC5:D37ECA3CF80CEEE3:D37DCA3CF80CEEE3=

> > [335776.845790] block drbd132: new current UUID
> > B243958413F455E9:E107A4DF8E316F71:F05164996BFE9341:F05064996BFE9341=

> > [335776.846148] block drbd133: new current UUID
> > 6E661C621E6C22E5:3271D34B1D818E09:6BA25176D9D79A5F:6BA15176D9D79A5F=

> > [335776.895617] drbd fastexport: Connection closed
> > [335776.895764] drbd fastexport: conn( ProtocolError -> Unconnected=
 )
> > [335776.895767] drbd fastexport: receiver terminated
> > [335776.895768] drbd fastexport: Restarting receiver thread
> > [335776.895769] drbd fastexport: receiver (re)started
> > [335776.895783] drbd fastexport: conn( Unconnected -> WFConnection =
)
> > [335782.092297] drbd fastexport: Handshake successful: Agreed netwo=
rk
> > protocol version 101 [335782.092301] drbd fastexport: Feature flags=

> > enabled on protocol level: 0x7 TRIM THIN_RESYNC WRITE_SAME.
> > [335782.092489] drbd fastexport: Peer authenticated using 32 bytes =
HMAC
> > [335782.092577] drbd fastexport: conn( WFConnection -> WFReportPara=
ms )
> > [335782.092587] drbd fastexport: Starting ack_recv thread (from
> > drbd_r_fastexpo [1925]) [335782.142516] block drbd131:
> > drbd_sync_handshake:
> > [335782.142522] block drbd131: self
> > E5F844267DB80A79:9823CD86802A0EC5:D37ECA3CF80CEEE3:D37DCA3CF80CEEE3=

> > bits:8180 flags:0 [335782.142527] block drbd131: peer
> > 9823CD86802A0EC4:0000000000000000:D37ECA3CF80CEEE2:D37DCA3CF80CEEE3=

> > bits:0 flags:0 [335782.142530] block drbd131: uuid_compare()=3D1 by=
 rule 70
> > [335782.142539] block drbd131: peer( Unknown -> Secondary ) conn(
> > WFReportParams -> WFBitMapS ) pdsk( DUnknown -> Consistent )
> > [335782.153913] block drbd131: send bitmap stats [Bytes(packets)]: =
plain
> > 0(0), RLE 438(1), total 438; compression: 100.0% [335782.178564] bl=
ock
> > drbd132: drbd_sync_handshake:
> > [335782.178570] block drbd132: self
> > B243958413F455E9:E107A4DF8E316F71:F05164996BFE9341:F05064996BFE9341=

> > bits:16198 flags:0 [335782.178574] block drbd132: peer
> > E107A4DF8E316F70:0000000000000000:F05164996BFE9340:F05064996BFE9341=

> > bits:0 flags:0 [335782.178578] block drbd132: uuid_compare()=3D1 by=
 rule 70
> > [335782.178587] block drbd132: peer( Unknown -> Secondary ) conn(
> > WFReportParams -> WFBitMapS ) pdsk( DUnknown -> Consistent )
> > [335782.191705] block drbd132: send bitmap stats [Bytes(packets)]: =
plain
> > 0(0), RLE 721(1), total 721; compression: 100.0% [335782.206444] bl=
ock
> > drbd133: drbd_sync_handshake:
> > [335782.206447] block drbd133: self
> > 6E661C621E6C22E5:3271D34B1D818E09:6BA25176D9D79A5F:6BA15176D9D79A5F=

> > bits:7775 flags:0 [335782.206450] block drbd133: peer
> > 3271D34B1D818E08:0000000000000000:6BA25176D9D79A5E:6BA15176D9D79A5F=

> > bits:0 flags:0 [335782.206452] block drbd133: uuid_compare()=3D1 by=
 rule 70
> > [335782.206459] block drbd133: peer( Unknown -> Secondary ) conn(
> > WFReportParams -> WFBitMapS ) pdsk( DUnknown -> Consistent )
> > [335782.206734] block drbd131: receive bitmap stats [Bytes(packets)=
]:
> > plain 0(0), RLE 438(1), total 438; compression: 100.0% [335782.2067=
38]
> > block drbd131: helper command: /sbin/drbdadm before-resync-source
> > minor-131 [335782.214351] block drbd131: helper command: /sbin/drbd=
adm
> > before-resync-source minor-131 exit code 0 (0x0) [335782.214376] bl=
ock
> > drbd131: conn( WFBitMapS -> SyncSource ) pdsk( Consistent -> Incons=
istent
> > ) [335782.214395] block drbd131: Began resync as SyncSource (will s=
ync
> > 33104 KB [8276 bits set]). [335782.214746] block drbd132: receive b=
itmap
> > stats [Bytes(packets)]: plain 0(0), RLE 721(1), total 721; compress=
ion:
> > 100.0% [335782.214749] block drbd132: helper command: /sbin/drbdadm=

> > before-resync-source minor-132 [335782.217368] block drbd132: helpe=
r
> > command: /sbin/drbdadm before-resync-source minor-132 exit code 0 (=
0x0)
> > [335782.217379] block drbd132: conn( WFBitMapS -> SyncSource ) pdsk=
(
> > Consistent -> Inconsistent ) [335782.217391] block drbd132: Began r=
esync
> > as SyncSource (will sync 65132 KB [16283 bits set]). [335782.218079=
]
> > block drbd133: send bitmap stats [Bytes(packets)]: plain 0(0), RLE
> > 290(1), total 290; compression: 100.0% [335782.218106] block drbd13=
1:
> > updated sync UUID
> > E5F844267DB80A79:9824CD86802A0EC5:9823CD86802A0EC5:D37ECA3CF80CEEE3=

> > [335782.218450] block drbd132: updated sync UUID
> > B243958413F455E9:E108A4DF8E316F71:E107A4DF8E316F71:F05164996BFE9341=

> > [335782.225868] block drbd133: receive bitmap stats [Bytes(packets)=
]:
> > plain 0(0), RLE 290(1), total 290; compression: 100.0% [335782.2258=
73]
> > block drbd133: helper command: /sbin/drbdadm before-resync-source
> > minor-133 [335782.227420] block drbd133: helper command: /sbin/drbd=
adm
> > before-resync-source minor-133 exit code 0 (0x0) [335782.227438] bl=
ock
> > drbd133: conn( WFBitMapS -> SyncSource ) pdsk( Consistent -> Incons=
istent
> > ) [335782.227461] block drbd133: Began resync as SyncSource (will s=
ync
> > 31456 KB [7864 bits set]). [335782.227508] block drbd133: updated s=
ync
> > UUID 6E661C621E6C22E5:3272D34B1D818E09:3271D34B1D818E09:6BA25176D9D=
79A5F
> > [335791.633014] block drbd133: Resync done (total 9 sec; paused 0 s=
ec;
> > 3492 K/sec) [335791.633020] block drbd133: 0 % had equal checksums,=

> > eliminated: 92K; transferred 31364K total 31456K [335791.633026] bl=
ock
> > drbd133: updated UUIDs
> > 6E661C621E6C22E5:0000000000000000:3272D34B1D818E09:3271D34B1D818E09=

> > [335791.633036] block drbd133: conn( SyncSource -> Connected ) pdsk=
(
> > Inconsistent -> UpToDate ) [335791.847326] block drbd131: Resync do=
ne
> > (total 9 sec; paused 0 sec; 3676 K/sec) [335791.847329] block drbd1=
31: 0
> > % had equal checksums, eliminated: 152K; transferred 32952K total 3=
3104K
> > [335791.847332] block drbd131: updated UUIDs
> > E5F844267DB80A79:0000000000000000:9824CD86802A0EC5:9823CD86802A0EC5=

> > [335791.847336] block drbd131: conn( SyncSource -> Connected ) pdsk=
(
> > Inconsistent -> UpToDate ) [335795.577446] block drbd132: Resync do=
ne
> > (total 13 sec; paused 0 sec; 5008 K/sec) [335795.577450] block drbd=
132: 0
> > % had equal checksums, eliminated: 32K; transferred 65100K total 65=
132K
> > [335795.577456] block drbd132: updated UUIDs
> > B243958413F455E9:0000000000000000:E108A4DF8E316F71:E107A4DF8E316F71=

> > [335795.577465] block drbd132: conn( SyncSource -> Connected ) pdsk=
(
> > Inconsistent -> UpToDate )
> >=20
> >=20
> >=20
> > Both times the difference between the BarrierAck was 1.
> >=20
> > We didn't use 4.19.79. We never saw this message with 4.19.78 or ea=
lier.
> >=20
> > After the first time this happened we saw a filesystem corruption.
> >=20
> >=20
> > Setup:
> >=20
> > The drbd fastexport consists of three volumes 1, 2 and 3
> >=20
> > Each volume is backed by a logical volume
> >=20
> > =09drbd_fastexport01
> > =09drbd_fastexport02
> > =09drbd_fastexport03
> >=20
> > of an LVM volumegroup
> >=20
> > =09drbddisks_fast
> >=20
> > This logical volumes are each on there own physical devices (which =
are
> > raid1).
> >=20
> > These raid1 are based on SSDs attached to an mpt3sas driven control=
ler.
> >=20
> >=20
> > (both sides are setup like that).
>=20
> Any chance you can run 'git bisect' between the two kernels (bad and
> good) and find the offending commit?

Thanks for your fast answer!

I already considered a bisect, but this will need a rather long time. T=
he=20
error yet happened only once with 4.19.80 and once with 4.19.81.

I bootet 4.19.81 on 2019-10-31 and the error happened on 2019-11-04. dr=
bd=20
revovered and I did not reboot the machine (I checked the filesystem, n=
o error=20
was found). Until today the error has not yet happened again.

So bisecting is rather difficult. I hoped the drbd people could explain=
 what=20
this error exactly means.

>=20
> Also, does 5.3.9 work for you?

Didn't try yet. It is our fileserver, so usually it is the last machine=
 I move=20
to a new longterm kernel and I also avoid all stable kernels in between=
 (for=20
that machine).

We use longterm kernels here and usually try to switch to the next long=
term=20
version as soon as available, starting with our routers. Then we switch=
 one=20
server after the other.

To avoid too many suprises we regularly run newest stable kernels on so=
me of=20
our machines. But never on our fileserver :-).

But 5.3 was not that bad, so I will try 5.3 next week and keep it as lo=
ng as=20
it does not show other problems.

Regards,
--=20
Wolfgang Walter
Studentenwerk M=FCnchen
Anstalt des =F6ffentlichen Rechts
