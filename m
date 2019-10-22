Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAB0DFE8B
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 09:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387739AbfJVHo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 03:44:56 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:51647 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387692AbfJVHo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Oct 2019 03:44:56 -0400
Received: from xps13 (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 4439D200011;
        Tue, 22 Oct 2019 07:44:52 +0000 (UTC)
Date:   Tue, 22 Oct 2019 09:44:51 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Richard Weinberger <richard@nod.at>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-mtd@lists.infradead.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mtd: spear_smi: Fix nonalignment not handled in
 memcpy_toio
Message-ID: <20191022094451.14d39206@xps13>
In-Reply-To: <20191021100105.0f06b212@collabora.com>
References: <20191018143643.29676-1-miquel.raynal@bootlin.com>
        <20191021100105.0f06b212@collabora.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/.VFqnn3JQLA7LyBnIYQjQ0i"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--MP_/.VFqnn3JQLA7LyBnIYQjQ0i
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

Boris Brezillon <boris.brezillon@collabora.com> wrote on Mon, 21 Oct
2019 10:01:05 +0200:

> On Fri, 18 Oct 2019 16:36:43 +0200
> Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>=20
> > Any write with either dd or flashcp to a device driven by the
> > spear_smi.c driver will pass through the spear_smi_cpy_toio()
> > function. This function will get called for chunks of up to 256 bytes.
> > If the amount of data is smaller, we may have a problem if the data
> > length is not 4-byte aligned. In this situation, the kernel panics
> > during the memcpy:
> >=20
> >     # dd if=3D/dev/urandom bs=3D1001 count=3D1 of=3D/dev/mtd6
> >     spear_smi_cpy_toio [620] dest c9070000, src c7be8800, len 256
> >     spear_smi_cpy_toio [620] dest c9070100, src c7be8900, len 256
> >     spear_smi_cpy_toio [620] dest c9070200, src c7be8a00, len 256
> >     spear_smi_cpy_toio [620] dest c9070300, src c7be8b00, len 233
> >     Unhandled fault: external abort on non-linefetch (0x808) at 0xc9070=
3e8
> >     [...]
> >     PC is at memcpy+0xcc/0x330 =20
>=20
> Can you find out which instruction is at memcpy+0xcc/0x330? For the
> record, the assembly is here [1].

The full disassembled file is attached, here is the failing part:

7:			ldmfd	sp!, {r5 - r8}
  b8:	e8bd01e0 	pop	{r5, r6, r7, r8}
	UNWIND(		.fnend				) @ end of second stmfd block

	UNWIND(		.fnstart			)
			usave	r4, lr			  @ still in first stmdb block
8:			movs	r2, r2, lsl #31
  bc:	e1b02f82 	lsls	r2, r2, #31
			ldr1b	r1, r3, ne, abort=3D21f
  c0:	14d13001 	ldrbne	r3, [r1], #1
			ldr1b	r1, r4, cs, abort=3D21f
  c4:	24d14001 	ldrbcs	r4, [r1], #1
			ldr1b	r1, ip, cs, abort=3D21f
  c8:	24d1c001 	ldrbcs	ip, [r1], #1
			str1b	r0, r3, ne, abort=3D21f
  cc:	14c03001 	strbne	r3, [r0], #1
			str1b	r0, r4, cs, abort=3D21f
  d0:	24c04001 	strbcs	r4, [r0], #1
			str1b	r0, ip, cs, abort=3D21f
  d4:	24c0c001 	strbcs	ip, [r0], #1

			exit	r4, pc
  d8:	e8bd8011 	pop	{r0, r4, pc}


So the fault is triggered on a strbne instruction.

> >=20
> > Workaround this issue by using the alternate _memcpy_toio() method
> > which at least does not present the same problem.
> >=20
> > Fixes: f18dbbb1bfe0 ("mtd: ST SPEAr: Add SMI driver for serial NOR flas=
h")
> > Cc: stable@vger.kernel.org
> > Suggested-by: Boris Brezillon <boris.brezillon@collabora.com> =20
>=20
> I don't remember suggesting that as a final solution. I probably
> suggested to test with _memcpy_toio() to see if using a byte accessor
> was fixing the problem, but it's definitely not the right solution
> (using byte access with a memory barrier for 256 bytes buffers is likely
> to cause a huge perf penalty).
>=20
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >=20
> > Hello,
> >=20
> > This patch could not be tested with a mainline kernel (only compiled)
> > but was tested with a stable 4.14.x kernel. I have really no idea why
> > memcpy fails in this situation that's why I propose this workaround
> > but I bet there is something deeper not working.
> >=20
> > Thanks,
> > Miqu=C3=A8l
> >=20
> >  drivers/mtd/devices/spear_smi.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/mtd/devices/spear_smi.c b/drivers/mtd/devices/spea=
r_smi.c
> > index 986f81d2f93e..d888625a3244 100644
> > --- a/drivers/mtd/devices/spear_smi.c
> > +++ b/drivers/mtd/devices/spear_smi.c
> > @@ -614,7 +614,7 @@ static inline int spear_smi_cpy_toio(struct spear_s=
mi *dev, u32 bank,
> >  	ctrlreg1 =3D readl(dev->io_base + SMI_CR1);
> >  	writel((ctrlreg1 | WB_MODE) & ~SW_MODE, dev->io_base + SMI_CR1);
> > =20
> > -	memcpy_toio(dest, src, len);
> > +	_memcpy_toio(dest, src, len);
> > =20
> >  	writel(ctrlreg1, dev->io_base + SMI_CR1);
> >   =20
>=20
> [1]https://elixir.bootlin.com/linux/v5.4-rc2/source/arch/arm/lib/memcpy.S


Thanks,
Miqu=C3=A8l

--MP_/.VFqnn3JQLA7LyBnIYQjQ0i
Content-Type: application/octet-stream; name=memcpy-disassemble
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=memcpy-disassemble

CmFyY2gvYXJtL2xpYi9tZW1jcHkubzogICAgIGZpbGUgZm9ybWF0IGVsZjMyLWxpdHRsZWFybQoK
CkRpc2Fzc2VtYmx5IG9mIHNlY3Rpb24gLnRleHQ6CgowMDAwMDAwMCA8bWVtY3B5PjoKICoJdGhh
biBvbmUgMzJiaXQgaW5zdHJ1Y3Rpb24gaW4gVGh1bWItMikKICovCgoKCVVOV0lORCgJLmZuc3Rh
cnQJCQkpCgkJZW50ZXIJcjQsIGxyCiAgIDA6CWU5MmQ0MDExIAlwdXNoCXtyMCwgcjQsIGxyfQoJ
VU5XSU5EKAkuZm5lbmQJCQkJKQoKCVVOV0lORCgJLmZuc3RhcnQJCQkpCgkJdXNhdmUJcjQsIGxy
CQkJICBAIGluIGZpcnN0IHN0bWRiIGJsb2NrCgoJCXN1YnMJcjIsIHIyLCAjNAogICA0OgllMjUy
MjAwNCAJc3VicwlyMiwgcjIsICM0CgkJYmx0CThmCiAgIDg6CWJhMDAwMDJiIAlibHQJYmMgPG1l
bWNweSsweGJjPgoJCWFuZHMJaXAsIHIwLCAjMwogICBjOgllMjEwYzAwMyAJYW5kcwlpcCwgcjAs
ICMzCglQTEQoCXBsZAlbcjEsICMwXQkJKQogIDEwOglmNWQxZjAwMCAJcGxkCVtyMV0KCQlibmUJ
OWYKICAxNDoJMWEwMDAwMzAgCWJuZQlkYyA8bWVtY3B5KzB4ZGM+CgkJYW5kcwlpcCwgcjEsICMz
CiAgMTg6CWUyMTFjMDAzIAlhbmRzCWlwLCByMSwgIzMKCQlibmUJMTBmCiAgMWM6CTFhMDAwMDNh
IAlibmUJMTBjIDxtZW1jcHkrMHgxMGM+CgoxOgkJc3VicwlyMiwgcjIsICMoMjgpCiAgMjA6CWUy
NTIyMDFjIAlzdWJzCXIyLCByMiwgIzI4CgkJc3RtZmQJc3AhLCB7cjUgLSByOH0KICAyNDoJZTky
ZDAxZTAgCXB1c2gJe3I1LCByNiwgcjcsIHI4fQoJVU5XSU5EKAkuZm5lbmQJCQkJKQoKCVVOV0lO
RCgJLmZuc3RhcnQJCQkpCgkJdXNhdmUJcjQsIGxyCglVTldJTkQoCS5zYXZlCXtyNSAtIHI4fQkJ
KSBAIGluIHNlY29uZCBzdG1mZCBibG9jawoJCWJsdAk1ZgogIDI4OgliYTAwMDAwYyAJYmx0CTYw
IDxtZW1jcHkrMHg2MD4KCUNBTEdOKAliY3MJMmYJCQkpCglDQUxHTigJYWRyCXI0LCA2ZgkJCSkK
CUNBTEdOKAlzdWJzCXIyLCByMiwgcjMJCSkgIEAgQyBnZXRzIHNldAoJQ0FMR04oCWFkZAlwYywg
cjQsIGlwCQkpCgoJUExEKAlwbGQJW3IxLCAjMF0JCSkKICAyYzoJZjVkMWYwMDAgCXBsZAlbcjFd
CjI6CVBMRCgJc3VicwlyMiwgcjIsICM5NgkJKQogIDMwOgllMjUyMjA2MCAJc3VicwlyMiwgcjIs
ICM5Ngk7IDB4NjAKCVBMRCgJcGxkCVtyMSwgIzI4XQkJKQogIDM0OglmNWQxZjAxYyAJcGxkCVty
MSwgIzI4XQoJUExEKAlibHQJNGYJCQkpCiAgMzg6CWJhMDAwMDAyIAlibHQJNDggPG1lbWNweSsw
eDQ4PgoJUExEKAlwbGQJW3IxLCAjNjBdCQkpCiAgM2M6CWY1ZDFmMDNjIAlwbGQJW3IxLCAjNjBd
CTsgMHgzYwoJUExEKAlwbGQJW3IxLCAjOTJdCQkpCiAgNDA6CWY1ZDFmMDVjIAlwbGQJW3IxLCAj
OTJdCTsgMHg1YwoKMzoJUExEKAlwbGQJW3IxLCAjMTI0XQkJKQogIDQ0OglmNWQxZjA3YyAJcGxk
CVtyMSwgIzEyNF0JOyAweDdjCjQ6CQlsZHI4dwlyMSwgcjMsIHI0LCByNSwgcjYsIHI3LCByOCwg
aXAsIGxyLCBhYm9ydD0yMGYKICA0ODoJZThiMTUxZjggCWxkbQlyMSEsIHtyMywgcjQsIHI1LCBy
NiwgcjcsIHI4LCBpcCwgbHJ9CgkJc3VicwlyMiwgcjIsICMzMgogIDRjOgllMjUyMjAyMCAJc3Vi
cwlyMiwgcjIsICMzMgoJCXN0cjh3CXIwLCByMywgcjQsIHI1LCByNiwgcjcsIHI4LCBpcCwgbHIs
IGFib3J0PTIwZgogIDUwOgllOGEwNTFmOCAJc3RtaWEJcjAhLCB7cjMsIHI0LCByNSwgcjYsIHI3
LCByOCwgaXAsIGxyfQoJCWJnZQkzYgogIDU0OglhYWZmZmZmYSAJYmdlCTQ0IDxtZW1jcHkrMHg0
ND4KCVBMRCgJY21uCXIyLCAjOTYJCQkpCiAgNTg6CWUzNzIwMDYwIAljbW4JcjIsICM5Ngk7IDB4
NjAKCVBMRCgJYmdlCTRiCQkJKQogIDVjOglhYWZmZmZmOSAJYmdlCTQ4IDxtZW1jcHkrMHg0OD4K
CjU6CQlhbmRzCWlwLCByMiwgIzI4CiAgNjA6CWUyMTJjMDFjIAlhbmRzCWlwLCByMiwgIzI4CgkJ
cnNiCWlwLCBpcCwgIzMyCiAgNjQ6CWUyNmNjMDIwIAlyc2IJaXAsIGlwLCAjMzIKI2lmIExEUjFX
X1NISUZUID4gMAoJCWxzbAlpcCwgaXAsICNMRFIxV19TSElGVAojZW5kaWYKCQlhZGRuZQlwYywg
cGMsIGlwCQlAIEMgaXMgYWx3YXlzIGNsZWFyIGhlcmUKICA2ODoJMTA4ZmYwMGMgCWFkZG5lCXBj
LCBwYywgaXAKCQliCTdmCiAgNmM6CWVhMDAwMDExIAliCWI4IDxtZW1jcHkrMHhiOD4KNjoKCQku
cmVwdAkoMSA8PCBMRFIxV19TSElGVCkKCQlXKG5vcCkKCQkuZW5kcgogIDcwOgllMWEwMDAwMCAJ
bm9wCQkJOyAobW92IHIwLCByMCkKCQlsZHIxdwlyMSwgcjMsIGFib3J0PTIwZgogIDc0OgllNDkx
MzAwNCAJbGRyCXIzLCBbcjFdLCAjNAoJCWxkcjF3CXIxLCByNCwgYWJvcnQ9MjBmCiAgNzg6CWU0
OTE0MDA0IAlsZHIJcjQsIFtyMV0sICM0CgkJbGRyMXcJcjEsIHI1LCBhYm9ydD0yMGYKICA3YzoJ
ZTQ5MTUwMDQgCWxkcglyNSwgW3IxXSwgIzQKCQlsZHIxdwlyMSwgcjYsIGFib3J0PTIwZgogIDgw
OgllNDkxNjAwNCAJbGRyCXI2LCBbcjFdLCAjNAoJCWxkcjF3CXIxLCByNywgYWJvcnQ9MjBmCiAg
ODQ6CWU0OTE3MDA0IAlsZHIJcjcsIFtyMV0sICM0CgkJbGRyMXcJcjEsIHI4LCBhYm9ydD0yMGYK
ICA4ODoJZTQ5MTgwMDQgCWxkcglyOCwgW3IxXSwgIzQKCQlsZHIxdwlyMSwgbHIsIGFib3J0PTIw
ZgogIDhjOgllNDkxZTAwNCAJbGRyCWxyLCBbcjFdLCAjNAojaWYgTERSMVdfU0hJRlQgPCBTVFIx
V19TSElGVAoJCWxzbAlpcCwgaXAsICNTVFIxV19TSElGVCAtIExEUjFXX1NISUZUCiNlbGlmIExE
UjFXX1NISUZUID4gU1RSMVdfU0hJRlQKCQlsc3IJaXAsIGlwLCAjTERSMVdfU0hJRlQgLSBTVFIx
V19TSElGVAojZW5kaWYKCQlhZGQJcGMsIHBjLCBpcAogIDkwOgllMDhmZjAwYyAJYWRkCXBjLCBw
YywgaXAKCQlub3AKICA5NDoJZTFhMDAwMDAgCW5vcAkJCTsgKG1vdiByMCwgcjApCgkJLnJlcHQJ
KDEgPDwgU1RSMVdfU0hJRlQpCgkJVyhub3ApCgkJLmVuZHIKICA5ODoJZTFhMDAwMDAgCW5vcAkJ
CTsgKG1vdiByMCwgcjApCgkJc3RyMXcJcjAsIHIzLCBhYm9ydD0yMGYKICA5YzoJZTQ4MDMwMDQg
CXN0cglyMywgW3IwXSwgIzQKCQlzdHIxdwlyMCwgcjQsIGFib3J0PTIwZgogIGEwOgllNDgwNDAw
NCAJc3RyCXI0LCBbcjBdLCAjNAoJCXN0cjF3CXIwLCByNSwgYWJvcnQ9MjBmCiAgYTQ6CWU0ODA1
MDA0IAlzdHIJcjUsIFtyMF0sICM0CgkJc3RyMXcJcjAsIHI2LCBhYm9ydD0yMGYKICBhODoJZTQ4
MDYwMDQgCXN0cglyNiwgW3IwXSwgIzQKCQlzdHIxdwlyMCwgcjcsIGFib3J0PTIwZgogIGFjOgll
NDgwNzAwNCAJc3RyCXI3LCBbcjBdLCAjNAoJCXN0cjF3CXIwLCByOCwgYWJvcnQ9MjBmCiAgYjA6
CWU0ODA4MDA0IAlzdHIJcjgsIFtyMF0sICM0CgkJc3RyMXcJcjAsIGxyLCBhYm9ydD0yMGYKICBi
NDoJZTQ4MGUwMDQgCXN0cglsciwgW3IwXSwgIzQKCglDQUxHTigJYmNzCTJiCQkJKQoKNzoJCWxk
bWZkCXNwISwge3I1IC0gcjh9CiAgYjg6CWU4YmQwMWUwIAlwb3AJe3I1LCByNiwgcjcsIHI4fQoJ
VU5XSU5EKAkuZm5lbmQJCQkJKSBAIGVuZCBvZiBzZWNvbmQgc3RtZmQgYmxvY2sKCglVTldJTkQo
CS5mbnN0YXJ0CQkJKQoJCXVzYXZlCXI0LCBscgkJCSAgQCBzdGlsbCBpbiBmaXJzdCBzdG1kYiBi
bG9jawo4OgkJbW92cwlyMiwgcjIsIGxzbCAjMzEKICBiYzoJZTFiMDJmODIgCWxzbHMJcjIsIHIy
LCAjMzEKCQlsZHIxYglyMSwgcjMsIG5lLCBhYm9ydD0yMWYKICBjMDoJMTRkMTMwMDEgCWxkcmJu
ZQlyMywgW3IxXSwgIzEKCQlsZHIxYglyMSwgcjQsIGNzLCBhYm9ydD0yMWYKICBjNDoJMjRkMTQw
MDEgCWxkcmJjcwlyNCwgW3IxXSwgIzEKCQlsZHIxYglyMSwgaXAsIGNzLCBhYm9ydD0yMWYKICBj
ODoJMjRkMWMwMDEgCWxkcmJjcwlpcCwgW3IxXSwgIzEKCQlzdHIxYglyMCwgcjMsIG5lLCBhYm9y
dD0yMWYKICBjYzoJMTRjMDMwMDEgCXN0cmJuZQlyMywgW3IwXSwgIzEKCQlzdHIxYglyMCwgcjQs
IGNzLCBhYm9ydD0yMWYKICBkMDoJMjRjMDQwMDEgCXN0cmJjcwlyNCwgW3IwXSwgIzEKCQlzdHIx
YglyMCwgaXAsIGNzLCBhYm9ydD0yMWYKICBkNDoJMjRjMGMwMDEgCXN0cmJjcwlpcCwgW3IwXSwg
IzEKCgkJZXhpdAlyNCwgcGMKICBkODoJZThiZDgwMTEgCXBvcAl7cjAsIHI0LCBwY30KCjk6CQly
c2IJaXAsIGlwLCAjNAogIGRjOgllMjZjYzAwNCAJcnNiCWlwLCBpcCwgIzQKCQljbXAJaXAsICMy
CiAgZTA6CWUzNWMwMDAyIAljbXAJaXAsICMyCgkJbGRyMWIJcjEsIHIzLCBndCwgYWJvcnQ9MjFm
CiAgZTQ6CWM0ZDEzMDAxIAlsZHJiZ3QJcjMsIFtyMV0sICMxCgkJbGRyMWIJcjEsIHI0LCBnZSwg
YWJvcnQ9MjFmCiAgZTg6CWE0ZDE0MDAxIAlsZHJiZ2UJcjQsIFtyMV0sICMxCgkJbGRyMWIJcjEs
IGxyLCBhYm9ydD0yMWYKICBlYzoJZTRkMWUwMDEgCWxkcmIJbHIsIFtyMV0sICMxCgkJc3RyMWIJ
cjAsIHIzLCBndCwgYWJvcnQ9MjFmCiAgZjA6CWM0YzAzMDAxIAlzdHJiZ3QJcjMsIFtyMF0sICMx
CgkJc3RyMWIJcjAsIHI0LCBnZSwgYWJvcnQ9MjFmCiAgZjQ6CWE0YzA0MDAxIAlzdHJiZ2UJcjQs
IFtyMF0sICMxCgkJc3VicwlyMiwgcjIsIGlwCiAgZjg6CWUwNTIyMDBjIAlzdWJzCXIyLCByMiwg
aXAKCQlzdHIxYglyMCwgbHIsIGFib3J0PTIxZgogIGZjOgllNGMwZTAwMSAJc3RyYglsciwgW3Iw
XSwgIzEKCQlibHQJOGIKIDEwMDoJYmFmZmZmZWQgCWJsdAliYyA8bWVtY3B5KzB4YmM+CgkJYW5k
cwlpcCwgcjEsICMzCiAxMDQ6CWUyMTFjMDAzIAlhbmRzCWlwLCByMSwgIzMKCQliZXEJMWIKIDEw
ODoJMGFmZmZmYzQgCWJlcQkyMCA8bWVtY3B5KzB4MjA+CgoxMDoJCWJpYwlyMSwgcjEsICMzCiAx
MGM6CWUzYzExMDAzIAliaWMJcjEsIHIxLCAjMwoJCWNtcAlpcCwgIzIKIDExMDoJZTM1YzAwMDIg
CWNtcAlpcCwgIzIKCQlsZHIxdwlyMSwgbHIsIGFib3J0PTIxZgogMTE0OgllNDkxZTAwNCAJbGRy
CWxyLCBbcjFdLCAjNAoJCWJlcQkxN2YKIDExODoJMGEwMDAwMmMgCWJlcQkxZDAgPG1lbWNweSsw
eDFkMD4KCQliZ3QJMThmCiAxMWM6CWNhMDAwMDU3IAliZ3QJMjgwIDxtZW1jcHkrMHgyODA+CglV
TldJTkQoCS5mbmVuZAkJCQkpCgoJCS5lbmRtCgoKCQlmb3J3YXJkX2NvcHlfc2hpZnQJcHVsbD04
CXB1c2g9MjQKIDEyMDoJZTI1MjIwMWMgCXN1YnMJcjIsIHIyLCAjMjgKIDEyNDoJYmEwMDAwMWYg
CWJsdAkxYTggPG1lbWNweSsweDFhOD4KIDEyODoJZTkyZDAzZTAgCXB1c2gJe3I1LCByNiwgcjcs
IHI4LCByOX0KIDEyYzoJZjVkMWYwMDAgCXBsZAlbcjFdCiAxMzA6CWUyNTIyMDYwIAlzdWJzCXIy
LCByMiwgIzk2CTsgMHg2MAogMTM0OglmNWQxZjAxYyAJcGxkCVtyMSwgIzI4XQogMTM4OgliYTAw
MDAwMiAJYmx0CTE0OCA8bWVtY3B5KzB4MTQ4PgogMTNjOglmNWQxZjAzYyAJcGxkCVtyMSwgIzYw
XQk7IDB4M2MKIDE0MDoJZjVkMWYwNWMgCXBsZAlbcjEsICM5Ml0JOyAweDVjCiAxNDQ6CWY1ZDFm
MDdjIAlwbGQJW3IxLCAjMTI0XQk7IDB4N2MKIDE0ODoJZThiMTAwZjAgCWxkbQlyMSEsIHtyNCwg
cjUsIHI2LCByN30KIDE0YzoJZTFhMDM0MmUgCWxzcglyMywgbHIsICM4CiAxNTA6CWUyNTIyMDIw
IAlzdWJzCXIyLCByMiwgIzMyCiAxNTQ6CWU4YjE1MzAwIAlsZG0JcjEhLCB7cjgsIHI5LCBpcCwg
bHJ9CiAxNTg6CWUxODMzYzA0IAlvcnIJcjMsIHIzLCByNCwgbHNsICMyNAogMTVjOgllMWEwNDQy
NCAJbHNyCXI0LCByNCwgIzgKIDE2MDoJZTE4NDRjMDUgCW9ycglyNCwgcjQsIHI1LCBsc2wgIzI0
CiAxNjQ6CWUxYTA1NDI1IAlsc3IJcjUsIHI1LCAjOAogMTY4OgllMTg1NWMwNiAJb3JyCXI1LCBy
NSwgcjYsIGxzbCAjMjQKIDE2YzoJZTFhMDY0MjYgCWxzcglyNiwgcjYsICM4CiAxNzA6CWUxODY2
YzA3IAlvcnIJcjYsIHI2LCByNywgbHNsICMyNAogMTc0OgllMWEwNzQyNyAJbHNyCXI3LCByNywg
IzgKIDE3ODoJZTE4NzdjMDggCW9ycglyNywgcjcsIHI4LCBsc2wgIzI0CiAxN2M6CWUxYTA4NDI4
IAlsc3IJcjgsIHI4LCAjOAogMTgwOgllMTg4OGMwOSAJb3JyCXI4LCByOCwgcjksIGxzbCAjMjQK
IDE4NDoJZTFhMDk0MjkgCWxzcglyOSwgcjksICM4CiAxODg6CWUxODk5YzBjIAlvcnIJcjksIHI5
LCBpcCwgbHNsICMyNAogMThjOgllMWEwYzQyYyAJbHNyCWlwLCBpcCwgIzgKIDE5MDoJZTE4Y2Nj
MGUgCW9ycglpcCwgaXAsIGxyLCBsc2wgIzI0CiAxOTQ6CWU4YTAxM2Y4IAlzdG1pYQlyMCEsIHty
MywgcjQsIHI1LCByNiwgcjcsIHI4LCByOSwgaXB9CiAxOTg6CWFhZmZmZmU5IAliZ2UJMTQ0IDxt
ZW1jcHkrMHgxNDQ+CiAxOWM6CWUzNzIwMDYwIAljbW4JcjIsICM5Ngk7IDB4NjAKIDFhMDoJYWFm
ZmZmZTggCWJnZQkxNDggPG1lbWNweSsweDE0OD4KIDFhNDoJZThiZDAzZTAgCXBvcAl7cjUsIHI2
LCByNywgcjgsIHI5fQogMWE4OgllMjEyYzAxYyAJYW5kcwlpcCwgcjIsICMyOAogMWFjOgkwYTAw
MDAwNSAJYmVxCTFjOCA8bWVtY3B5KzB4MWM4PgogMWIwOgllMWEwMzQyZSAJbHNyCXIzLCBsciwg
IzgKIDFiNDoJZTQ5MWUwMDQgCWxkcglsciwgW3IxXSwgIzQKIDFiODoJZTI1Y2MwMDQgCXN1YnMJ
aXAsIGlwLCAjNAogMWJjOgllMTgzM2MwZSAJb3JyCXIzLCByMywgbHIsIGxzbCAjMjQKIDFjMDoJ
ZTQ4MDMwMDQgCXN0cglyMywgW3IwXSwgIzQKIDFjNDoJY2FmZmZmZjkgCWJndAkxYjAgPG1lbWNw
eSsweDFiMD4KIDFjODoJZTI0MTEwMDMgCXN1YglyMSwgcjEsICMzCiAxY2M6CWVhZmZmZmJhIAli
CWJjIDxtZW1jcHkrMHhiYz4KCjE3OgkJZm9yd2FyZF9jb3B5X3NoaWZ0CXB1bGw9MTYJcHVzaD0x
NgogMWQwOgllMjUyMjAxYyAJc3VicwlyMiwgcjIsICMyOAogMWQ0OgliYTAwMDAxZiAJYmx0CTI1
OCA8bWVtY3B5KzB4MjU4PgogMWQ4OgllOTJkMDNlMCAJcHVzaAl7cjUsIHI2LCByNywgcjgsIHI5
fQogMWRjOglmNWQxZjAwMCAJcGxkCVtyMV0KIDFlMDoJZTI1MjIwNjAgCXN1YnMJcjIsIHIyLCAj
OTYJOyAweDYwCiAxZTQ6CWY1ZDFmMDFjIAlwbGQJW3IxLCAjMjhdCiAxZTg6CWJhMDAwMDAyIAli
bHQJMWY4IDxtZW1jcHkrMHgxZjg+CiAxZWM6CWY1ZDFmMDNjIAlwbGQJW3IxLCAjNjBdCTsgMHgz
YwogMWYwOglmNWQxZjA1YyAJcGxkCVtyMSwgIzkyXQk7IDB4NWMKIDFmNDoJZjVkMWYwN2MgCXBs
ZAlbcjEsICMxMjRdCTsgMHg3YwogMWY4OgllOGIxMDBmMCAJbGRtCXIxISwge3I0LCByNSwgcjYs
IHI3fQogMWZjOgllMWEwMzgyZSAJbHNyCXIzLCBsciwgIzE2CiAyMDA6CWUyNTIyMDIwIAlzdWJz
CXIyLCByMiwgIzMyCiAyMDQ6CWU4YjE1MzAwIAlsZG0JcjEhLCB7cjgsIHI5LCBpcCwgbHJ9CiAy
MDg6CWUxODMzODA0IAlvcnIJcjMsIHIzLCByNCwgbHNsICMxNgogMjBjOgllMWEwNDgyNCAJbHNy
CXI0LCByNCwgIzE2CiAyMTA6CWUxODQ0ODA1IAlvcnIJcjQsIHI0LCByNSwgbHNsICMxNgogMjE0
OgllMWEwNTgyNSAJbHNyCXI1LCByNSwgIzE2CiAyMTg6CWUxODU1ODA2IAlvcnIJcjUsIHI1LCBy
NiwgbHNsICMxNgogMjFjOgllMWEwNjgyNiAJbHNyCXI2LCByNiwgIzE2CiAyMjA6CWUxODY2ODA3
IAlvcnIJcjYsIHI2LCByNywgbHNsICMxNgogMjI0OgllMWEwNzgyNyAJbHNyCXI3LCByNywgIzE2
CiAyMjg6CWUxODc3ODA4IAlvcnIJcjcsIHI3LCByOCwgbHNsICMxNgogMjJjOgllMWEwODgyOCAJ
bHNyCXI4LCByOCwgIzE2CiAyMzA6CWUxODg4ODA5IAlvcnIJcjgsIHI4LCByOSwgbHNsICMxNgog
MjM0OgllMWEwOTgyOSAJbHNyCXI5LCByOSwgIzE2CiAyMzg6CWUxODk5ODBjIAlvcnIJcjksIHI5
LCBpcCwgbHNsICMxNgogMjNjOgllMWEwYzgyYyAJbHNyCWlwLCBpcCwgIzE2CiAyNDA6CWUxOGNj
ODBlIAlvcnIJaXAsIGlwLCBsciwgbHNsICMxNgogMjQ0OgllOGEwMTNmOCAJc3RtaWEJcjAhLCB7
cjMsIHI0LCByNSwgcjYsIHI3LCByOCwgcjksIGlwfQogMjQ4OglhYWZmZmZlOSAJYmdlCTFmNCA8
bWVtY3B5KzB4MWY0PgogMjRjOgllMzcyMDA2MCAJY21uCXIyLCAjOTYJOyAweDYwCiAyNTA6CWFh
ZmZmZmU4IAliZ2UJMWY4IDxtZW1jcHkrMHgxZjg+CiAyNTQ6CWU4YmQwM2UwIAlwb3AJe3I1LCBy
NiwgcjcsIHI4LCByOX0KIDI1ODoJZTIxMmMwMWMgCWFuZHMJaXAsIHIyLCAjMjgKIDI1YzoJMGEw
MDAwMDUgCWJlcQkyNzggPG1lbWNweSsweDI3OD4KIDI2MDoJZTFhMDM4MmUgCWxzcglyMywgbHIs
ICMxNgogMjY0OgllNDkxZTAwNCAJbGRyCWxyLCBbcjFdLCAjNAogMjY4OgllMjVjYzAwNCAJc3Vi
cwlpcCwgaXAsICM0CiAyNmM6CWUxODMzODBlIAlvcnIJcjMsIHIzLCBsciwgbHNsICMxNgogMjcw
OgllNDgwMzAwNCAJc3RyCXIzLCBbcjBdLCAjNAogMjc0OgljYWZmZmZmOSAJYmd0CTI2MCA8bWVt
Y3B5KzB4MjYwPgogMjc4OgllMjQxMTAwMiAJc3ViCXIxLCByMSwgIzIKIDI3YzoJZWFmZmZmOGUg
CWIJYmMgPG1lbWNweSsweGJjPgoKMTg6CQlmb3J3YXJkX2NvcHlfc2hpZnQJcHVsbD0yNAlwdXNo
PTgKIDI4MDoJZTI1MjIwMWMgCXN1YnMJcjIsIHIyLCAjMjgKIDI4NDoJYmEwMDAwMWYgCWJsdAkz
MDggPG1lbWNweSsweDMwOD4KIDI4ODoJZTkyZDAzZTAgCXB1c2gJe3I1LCByNiwgcjcsIHI4LCBy
OX0KIDI4YzoJZjVkMWYwMDAgCXBsZAlbcjFdCiAyOTA6CWUyNTIyMDYwIAlzdWJzCXIyLCByMiwg
Izk2CTsgMHg2MAogMjk0OglmNWQxZjAxYyAJcGxkCVtyMSwgIzI4XQogMjk4OgliYTAwMDAwMiAJ
Ymx0CTJhOCA8bWVtY3B5KzB4MmE4PgogMjljOglmNWQxZjAzYyAJcGxkCVtyMSwgIzYwXQk7IDB4
M2MKIDJhMDoJZjVkMWYwNWMgCXBsZAlbcjEsICM5Ml0JOyAweDVjCiAyYTQ6CWY1ZDFmMDdjIAlw
bGQJW3IxLCAjMTI0XQk7IDB4N2MKIDJhODoJZThiMTAwZjAgCWxkbQlyMSEsIHtyNCwgcjUsIHI2
LCByN30KIDJhYzoJZTFhMDNjMmUgCWxzcglyMywgbHIsICMyNAogMmIwOgllMjUyMjAyMCAJc3Vi
cwlyMiwgcjIsICMzMgogMmI0OgllOGIxNTMwMCAJbGRtCXIxISwge3I4LCByOSwgaXAsIGxyfQog
MmI4OgllMTgzMzQwNCAJb3JyCXIzLCByMywgcjQsIGxzbCAjOAogMmJjOgllMWEwNGMyNCAJbHNy
CXI0LCByNCwgIzI0CiAyYzA6CWUxODQ0NDA1IAlvcnIJcjQsIHI0LCByNSwgbHNsICM4CiAyYzQ6
CWUxYTA1YzI1IAlsc3IJcjUsIHI1LCAjMjQKIDJjODoJZTE4NTU0MDYgCW9ycglyNSwgcjUsIHI2
LCBsc2wgIzgKIDJjYzoJZTFhMDZjMjYgCWxzcglyNiwgcjYsICMyNAogMmQwOgllMTg2NjQwNyAJ
b3JyCXI2LCByNiwgcjcsIGxzbCAjOAogMmQ0OgllMWEwN2MyNyAJbHNyCXI3LCByNywgIzI0CiAy
ZDg6CWUxODc3NDA4IAlvcnIJcjcsIHI3LCByOCwgbHNsICM4CiAyZGM6CWUxYTA4YzI4IAlsc3IJ
cjgsIHI4LCAjMjQKIDJlMDoJZTE4ODg0MDkgCW9ycglyOCwgcjgsIHI5LCBsc2wgIzgKIDJlNDoJ
ZTFhMDljMjkgCWxzcglyOSwgcjksICMyNAogMmU4OgllMTg5OTQwYyAJb3JyCXI5LCByOSwgaXAs
IGxzbCAjOAogMmVjOgllMWEwY2MyYyAJbHNyCWlwLCBpcCwgIzI0CiAyZjA6CWUxOGNjNDBlIAlv
cnIJaXAsIGlwLCBsciwgbHNsICM4CiAyZjQ6CWU4YTAxM2Y4IAlzdG1pYQlyMCEsIHtyMywgcjQs
IHI1LCByNiwgcjcsIHI4LCByOSwgaXB9CiAyZjg6CWFhZmZmZmU5IAliZ2UJMmE0IDxtZW1jcHkr
MHgyYTQ+CiAyZmM6CWUzNzIwMDYwIAljbW4JcjIsICM5Ngk7IDB4NjAKIDMwMDoJYWFmZmZmZTgg
CWJnZQkyYTggPG1lbWNweSsweDJhOD4KIDMwNDoJZThiZDAzZTAgCXBvcAl7cjUsIHI2LCByNywg
cjgsIHI5fQogMzA4OgllMjEyYzAxYyAJYW5kcwlpcCwgcjIsICMyOAogMzBjOgkwYTAwMDAwNSAJ
YmVxCTMyOCA8bWVtY3B5KzB4MzI4PgogMzEwOgllMWEwM2MyZSAJbHNyCXIzLCBsciwgIzI0CiAz
MTQ6CWU0OTFlMDA0IAlsZHIJbHIsIFtyMV0sICM0CiAzMTg6CWUyNWNjMDA0IAlzdWJzCWlwLCBp
cCwgIzQKIDMxYzoJZTE4MzM0MGUgCW9ycglyMywgcjMsIGxyLCBsc2wgIzgKIDMyMDoJZTQ4MDMw
MDQgCXN0cglyMywgW3IwXSwgIzQKIDMyNDoJY2FmZmZmZjkgCWJndAkzMTAgPG1lbWNweSsweDMx
MD4KIDMyODoJZTI0MTEwMDEgCXN1YglyMSwgcjEsICMxCiAzMmM6CWVhZmZmZjYyIAliCWJjIDxt
ZW1jcHkrMHhiYz4K

--MP_/.VFqnn3JQLA7LyBnIYQjQ0i--
