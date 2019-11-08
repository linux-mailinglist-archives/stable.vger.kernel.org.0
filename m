Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99CD1F5174
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 17:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfKHQqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 11:46:21 -0500
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:32872 "EHLO
        email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbfKHQqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 11:46:21 -0500
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Nov 2019 11:46:19 EST
Received: from mailhub.studentenwerk.mhn.de (mailhub.studentenwerk.mhn.de [127.0.0.1])
        by email.studentenwerk.mhn.de (Postfix) with ESMTPS id 478mD60S1yzRhSv;
        Fri,  8 Nov 2019 17:38:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de; s=stwm-20170627;
        t=1573231094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=i2BtU/hBupkDMHXxiVaHxzTNlK3wPbIwuEDTrzxO1z8=;
        b=pCwcd+p1bpgdiEF7373tBqPy2/eD9FZMPPC0SVjSAoasQtDF+EksXSx7jVHx1fG0mP3TWS
        OVfQ65Dvy71L/zfnHkX9/H41e9377li0+R5pNV4QOGLaATlSTupFHm5Mgow4MVlxpzBTu2
        4pUdySv7V/CIKPV3lEPzIzFsPKHKaxYvUPZ9aKg9fu00dBKiSSEQToelr1B3BtoPHE82vm
        MmuVGMSnovid/bj4GOtDATEU0QLfXgFPe5AlVkAPzxqPVWR3Pkj5lCIlFPveoJaEv7u3eY
        en9EMvqi4Gdtoq98IK992afVMVdBuOJObxryoI3m1F5rzbm0ZF03TyETaPitLA==
From:   Wolfgang Walter <linux@stwm.de>
To:     drbd-dev@lists.linbit.com
Cc:     stable@vger.kernel.org
Subject: stable 4.19.80 and 4.19.81: BAD! BarrierAck seen in drbd
Date:   Fri, 08 Nov 2019 17:38:13 +0100
Message-ID: <4418981.SUHPA3XYOi@stwm.de>
User-Agent: KMail/4.14.3 (Linux/5.0.6-050006-generic; KDE/4.14.13; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de;
        s=stwm-20170627; t=1573231094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=i2BtU/hBupkDMHXxiVaHxzTNlK3wPbIwuEDTrzxO1z8=;
        b=HmN9p7Dv95QmlELMiblPsYSo6c9EA1ZtxqCm8CEKf6ZIn0yoK71l5yhUID8xU97kxquAJx
        loUU06p3g8J6bCuja0mW1RK6qzBbiFCbHkBE+VftiI3/u7dlV+gssNak0aLXzPeX5+9D10
        /ijGBkzKIDdrw1INpbV4WHWOHCQO3YStLoGrkd6qbxYVbjt5aRQ1K7M0Qt0ZVWtod8zvjl
        EkoCiWMDMOc8EjCtW2Wb1ReMC4B1/6DpebinZX1fnIYH/Vfy9d3/l9l2Au+++twmtolRHP
        lnOLmzPySyWexCU2OyIpOfvxbnIPSU269NPlDw8oi9Ok94kaaO6m2OUhqVzl6A==
ARC-Seal: i=1; s=stwm-20170627; d=stwm.de; t=1573231094; a=rsa-sha256;
        cv=none;
        b=XXKWmDLeSx2UuxIn5AqCMaFv3NzcXcLqfJBcVLUdP1321i7yxhFZr1Xtuu3Z+vLazITlp+
        OCkRw9V0ltgRk4cT4januBi64H4gmIIToDA6HtIEK5KE7WypRQnbEKnScnjMPnAESlrcmx
        RrQ+BnkLsMWqXNYhwvlKrELT/jn2XKNWBdnbARrzYNDo6M5dqXwMWRnq2nYIRLUTkJJ/RU
        hEcPlQFpQQpYC+UJVw9MaqRUfcM+auC15sbeLG2qYrjWNvdrj0gHLi7nARbjVW+vBSZ7Te
        9b2W8XOIgYDRcHPa/Dc1ocx37o4w7pYzHobxAa0x5TIfJk+aY4CDtillXYfjaA==
ARC-Authentication-Results: i=1;
        email.studentenwerk.mhn.de;
        none
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

starting with 4.19.80 we saw twice this message from drbd (primary):

[335776.845165] drbd fastexport: BAD! BarrierAck #24834877 received, ex=
pected #24834876!
[335776.845272] drbd fastexport: peer( Secondary -> Unknown ) conn( Con=
nected -> ProtocolError ) pdsk( UpToDate -> DUnknown )=20
[335776.845359] drbd fastexport: ack_receiver terminated
[335776.845361] drbd fastexport: Terminating drbd_a_fastexpo
[335776.845452] block drbd131: new current UUID E5F844267DB80A79:9823CD=
86802A0EC5:D37ECA3CF80CEEE3:D37DCA3CF80CEEE3
[335776.845790] block drbd132: new current UUID B243958413F455E9:E107A4=
DF8E316F71:F05164996BFE9341:F05064996BFE9341
[335776.846148] block drbd133: new current UUID 6E661C621E6C22E5:3271D3=
4B1D818E09:6BA25176D9D79A5F:6BA15176D9D79A5F
[335776.895617] drbd fastexport: Connection closed
[335776.895764] drbd fastexport: conn( ProtocolError -> Unconnected )=20=

[335776.895767] drbd fastexport: receiver terminated
[335776.895768] drbd fastexport: Restarting receiver thread
[335776.895769] drbd fastexport: receiver (re)started
[335776.895783] drbd fastexport: conn( Unconnected -> WFConnection )=20=

[335782.092297] drbd fastexport: Handshake successful: Agreed network p=
rotocol version 101
[335782.092301] drbd fastexport: Feature flags enabled on protocol leve=
l: 0x7 TRIM THIN_RESYNC WRITE_SAME.
[335782.092489] drbd fastexport: Peer authenticated using 32 bytes HMAC=

[335782.092577] drbd fastexport: conn( WFConnection -> WFReportParams )=
=20
[335782.092587] drbd fastexport: Starting ack_recv thread (from drbd_r_=
fastexpo [1925])
[335782.142516] block drbd131: drbd_sync_handshake:
[335782.142522] block drbd131: self E5F844267DB80A79:9823CD86802A0EC5:D=
37ECA3CF80CEEE3:D37DCA3CF80CEEE3 bits:8180 flags:0
[335782.142527] block drbd131: peer 9823CD86802A0EC4:0000000000000000:D=
37ECA3CF80CEEE2:D37DCA3CF80CEEE3 bits:0 flags:0
[335782.142530] block drbd131: uuid_compare()=3D1 by rule 70
[335782.142539] block drbd131: peer( Unknown -> Secondary ) conn( WFRep=
ortParams -> WFBitMapS ) pdsk( DUnknown -> Consistent )=20
[335782.153913] block drbd131: send bitmap stats [Bytes(packets)]: plai=
n 0(0), RLE 438(1), total 438; compression: 100.0%
[335782.178564] block drbd132: drbd_sync_handshake:
[335782.178570] block drbd132: self B243958413F455E9:E107A4DF8E316F71:F=
05164996BFE9341:F05064996BFE9341 bits:16198 flags:0
[335782.178574] block drbd132: peer E107A4DF8E316F70:0000000000000000:F=
05164996BFE9340:F05064996BFE9341 bits:0 flags:0
[335782.178578] block drbd132: uuid_compare()=3D1 by rule 70
[335782.178587] block drbd132: peer( Unknown -> Secondary ) conn( WFRep=
ortParams -> WFBitMapS ) pdsk( DUnknown -> Consistent )=20
[335782.191705] block drbd132: send bitmap stats [Bytes(packets)]: plai=
n 0(0), RLE 721(1), total 721; compression: 100.0%
[335782.206444] block drbd133: drbd_sync_handshake:
[335782.206447] block drbd133: self 6E661C621E6C22E5:3271D34B1D818E09:6=
BA25176D9D79A5F:6BA15176D9D79A5F bits:7775 flags:0
[335782.206450] block drbd133: peer 3271D34B1D818E08:0000000000000000:6=
BA25176D9D79A5E:6BA15176D9D79A5F bits:0 flags:0
[335782.206452] block drbd133: uuid_compare()=3D1 by rule 70
[335782.206459] block drbd133: peer( Unknown -> Secondary ) conn( WFRep=
ortParams -> WFBitMapS ) pdsk( DUnknown -> Consistent )=20
[335782.206734] block drbd131: receive bitmap stats [Bytes(packets)]: p=
lain 0(0), RLE 438(1), total 438; compression: 100.0%
[335782.206738] block drbd131: helper command: /sbin/drbdadm before-res=
ync-source minor-131
[335782.214351] block drbd131: helper command: /sbin/drbdadm before-res=
ync-source minor-131 exit code 0 (0x0)
[335782.214376] block drbd131: conn( WFBitMapS -> SyncSource ) pdsk( Co=
nsistent -> Inconsistent )=20
[335782.214395] block drbd131: Began resync as SyncSource (will sync 33=
104 KB [8276 bits set]).
[335782.214746] block drbd132: receive bitmap stats [Bytes(packets)]: p=
lain 0(0), RLE 721(1), total 721; compression: 100.0%
[335782.214749] block drbd132: helper command: /sbin/drbdadm before-res=
ync-source minor-132
[335782.217368] block drbd132: helper command: /sbin/drbdadm before-res=
ync-source minor-132 exit code 0 (0x0)
[335782.217379] block drbd132: conn( WFBitMapS -> SyncSource ) pdsk( Co=
nsistent -> Inconsistent )=20
[335782.217391] block drbd132: Began resync as SyncSource (will sync 65=
132 KB [16283 bits set]).
[335782.218079] block drbd133: send bitmap stats [Bytes(packets)]: plai=
n 0(0), RLE 290(1), total 290; compression: 100.0%
[335782.218106] block drbd131: updated sync UUID E5F844267DB80A79:9824C=
D86802A0EC5:9823CD86802A0EC5:D37ECA3CF80CEEE3
[335782.218450] block drbd132: updated sync UUID B243958413F455E9:E108A=
4DF8E316F71:E107A4DF8E316F71:F05164996BFE9341
[335782.225868] block drbd133: receive bitmap stats [Bytes(packets)]: p=
lain 0(0), RLE 290(1), total 290; compression: 100.0%
[335782.225873] block drbd133: helper command: /sbin/drbdadm before-res=
ync-source minor-133
[335782.227420] block drbd133: helper command: /sbin/drbdadm before-res=
ync-source minor-133 exit code 0 (0x0)
[335782.227438] block drbd133: conn( WFBitMapS -> SyncSource ) pdsk( Co=
nsistent -> Inconsistent )=20
[335782.227461] block drbd133: Began resync as SyncSource (will sync 31=
456 KB [7864 bits set]).
[335782.227508] block drbd133: updated sync UUID 6E661C621E6C22E5:3272D=
34B1D818E09:3271D34B1D818E09:6BA25176D9D79A5F
[335791.633014] block drbd133: Resync done (total 9 sec; paused 0 sec; =
3492 K/sec)
[335791.633020] block drbd133: 0 % had equal checksums, eliminated: 92K=
; transferred 31364K total 31456K
[335791.633026] block drbd133: updated UUIDs 6E661C621E6C22E5:000000000=
0000000:3272D34B1D818E09:3271D34B1D818E09
[335791.633036] block drbd133: conn( SyncSource -> Connected ) pdsk( In=
consistent -> UpToDate )=20
[335791.847326] block drbd131: Resync done (total 9 sec; paused 0 sec; =
3676 K/sec)
[335791.847329] block drbd131: 0 % had equal checksums, eliminated: 152=
K; transferred 32952K total 33104K
[335791.847332] block drbd131: updated UUIDs E5F844267DB80A79:000000000=
0000000:9824CD86802A0EC5:9823CD86802A0EC5
[335791.847336] block drbd131: conn( SyncSource -> Connected ) pdsk( In=
consistent -> UpToDate )=20
[335795.577446] block drbd132: Resync done (total 13 sec; paused 0 sec;=
 5008 K/sec)
[335795.577450] block drbd132: 0 % had equal checksums, eliminated: 32K=
; transferred 65100K total 65132K
[335795.577456] block drbd132: updated UUIDs B243958413F455E9:000000000=
0000000:E108A4DF8E316F71:E107A4DF8E316F71
[335795.577465] block drbd132: conn( SyncSource -> Connected ) pdsk( In=
consistent -> UpToDate )



Both times the difference between the BarrierAck was 1.

We didn't use 4.19.79. We never saw this message with 4.19.78 or ealier=
.

After the first time this happened we saw a filesystem corruption.


Setup:

The drbd fastexport consists of three volumes 1, 2 and 3

Each volume is backed by a logical volume

=09drbd_fastexport01
=09drbd_fastexport02
=09drbd_fastexport03
=09
of an LVM volumegroup
=09drbddisks_fast

This logical volumes are each on there own physical devices (which are =
raid1).

These raid1 are based on SSDs attached to an mpt3sas driven controller.=



(both sides are setup like that).


Regards,
--=20
Wolfgang Walter
Studentenwerk M=FCnchen
Anstalt des =F6ffentlichen Rechts
